# frozen_string_literal: true

module Experiments
  class EvaluateAndEvolve < GLCommand::Callable
    requires experiment: Experiment
    returns :new_generation # The newly created and populated Generation

    # For rollback
    attr_accessor :previous_generation_id_for_rollback,
                  :new_generation_id_for_rollback,
                  :original_organism_fitness_values_for_rollback # Hash { organism_id => original_fitness }

    def call
      current_generation = context.experiment.current_generation
      unless current_generation
        fail_command!(errors: { experiment: ['does not have a current generation to evaluate'] })
        return
      end

      # Ensure experiment is running
      context.experiment.start! if context.experiment.may_start?

      unless context.experiment.running?
        fail_command!(errors: { experiment: ["must be in 'running' state to evaluate and evolve (current: #{context.experiment.status})"] })
        return
      end

      organisms_to_evaluate = current_generation.organisms.to_a
      if organisms_to_evaluate.empty?
        fail_command!(errors: { generation: ['current generation has no organisms to evaluate'] })
        return
      end

      # Store for potential full rollback if this command is part of a chain
      self.previous_generation_id_for_rollback = current_generation.id
      self.original_organism_fitness_values_for_rollback = {}

      ActiveRecord::Base.transaction do
        # 1. Evaluate Fitness
        organisms_to_evaluate.each do |organism|
          # Store original fitness for detailed rollback
          original_organism_fitness_values_for_rollback[organism.id] = organism.fitness

          performance_logs = PerformanceLog.where(
            experiment_id: context.experiment.id,
            organism_id: organism.id
          ).where.not(fitness_input_value: nil) # Only consider logs with fitness input

          new_fitness = if performance_logs.any?
                          performance_logs.average(:fitness_input_value)
                        else
                          0.0 # Default fitness if no relevant performance logs
                        end

          unless organism.update(fitness: new_fitness)
            errors.add(:base, "Failed to update fitness for organism #{organism.id}")
            errors.merge!(organism.errors)
            fail_command!(errors:)
            raise ActiveRecord::Rollback
          end
        end

        # 2. Create Offspring Generation record
        population_size = context.experiment.configuration.fetch('population_size', 10) # Ensure string/symbol key consistency
        
        @new_offspring_generation = Generation.new(
          chromosome: context.experiment.chromosome,
          iteration: current_generation.iteration + 1
        )
        unless @new_offspring_generation.save
          errors.add(:base, "Failed to create new generation record for evolution.")
          errors.merge!(@new_offspring_generation.errors)
          fail_command!(errors:)
          raise ActiveRecord::Rollback
        end
        self.new_generation_id_for_rollback = @new_offspring_generation.id


        # 3. Evolve: Call Generations::New
        # Generations::New requires parent_generation and offspring_generation (which it populates)
        evolve_result = Generations::New.call(
          parent_generation: current_generation, # Now has updated fitness values
          offspring_generation: @new_offspring_generation,
          organism_count: population_size
        )

        unless evolve_result.success?
          errors.add(:base, "Evolution (Generations::New) failed.")
          errors.merge!(evolve_result.errors)
          # @new_offspring_generation was created, but Generations::New failed to populate it.
          # The transaction rollback will destroy @new_offspring_generation.
          fail_command!(errors:)
          raise ActiveRecord::Rollback
        end

        # 4. Update Experiment's current generation
        context.experiment.current_generation = @new_offspring_generation
        unless context.experiment.save
          errors.add(:base, "Failed to update experiment with new current generation.")
          errors.merge!(context.experiment.errors)
          fail_command!(errors:)
          raise ActiveRecord::Rollback
        end

        context.new_generation = @new_offspring_generation
      end # End of transaction
    rescue ActiveRecord::Rollback
      # Errors already set by fail_command!
      # Clear context returns if transaction failed
      context.new_generation = nil
    end

    def rollback
      # This is called if EvaluateAndEvolve succeeded, but a later command in a chain failed.
      # We need to revert the experiment's current_generation and destroy the new_generation.
      # Also, revert fitness values on the organisms of the previous generation.

      return unless new_generation_id_for_rollback && previous_generation_id_for_rollback

      experiment_to_revert = context.experiment # Experiment instance from context
      newly_created_generation = Generation.find_by(id: new_generation_id_for_rollback)
      previous_generation = Generation.find_by(id: previous_generation_id_for_rollback)

      if experiment_to_revert && previous_generation
        experiment_to_revert.current_generation = previous_generation
        experiment_to_revert.save # Consider potential failure here, though less likely
      end

      # Revert fitness values on organisms of the previous generation
      if previous_generation && original_organism_fitness_values_for_rollback.present?
        Organism.where(id: original_organism_fitness_values_for_rollback.keys).each do |org|
          org.update(fitness: original_organism_fitness_values_for_rollback[org.id])
        end
      end

      newly_created_generation.destroy if newly_created_generation&.persisted?
      
      # Clear context returns as they are no longer valid
      context.new_generation = nil
    end
  end
end
