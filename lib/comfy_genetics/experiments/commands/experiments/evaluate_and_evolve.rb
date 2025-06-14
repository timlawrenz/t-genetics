# frozen_string_literal: true

module ComfyGenetics
  module Experiments
    class EvaluateAndEvolve < GLCommand::Callable # TODO: GLCommand
      requires experiment: ComfyGenetics::Experiment
      returns :new_generation # The newly created and populated Generation TODO: ComfyGenetics::Generation

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

            # TODO: ComfyGenetics::PerformanceLog
            performance_logs = ComfyGenetics::PerformanceLog.where(
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
          population_size = context.experiment.configuration.fetch('population_size', 10)

          # TODO: ComfyGenetics::Generation
          @new_offspring_generation = ComfyGenetics::Generation.new(
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
          # TODO: ComfyGenetics::Generations::New
          evolve_result = ComfyGenetics::Generations::New.call(
            parent_generation: current_generation,
            offspring_generation: @new_offspring_generation,
            organism_count: population_size
          )

          unless evolve_result.success?
            errors.add(:base, "Evolution (Generations::New) failed.")
            errors.merge!(evolve_result.errors)
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
        context.new_generation = nil
      end

      def rollback
        return unless new_generation_id_for_rollback && previous_generation_id_for_rollback

        experiment_to_revert = context.experiment
        # TODO: ComfyGenetics::Generation
        newly_created_generation = ComfyGenetics::Generation.find_by(id: new_generation_id_for_rollback)
        previous_generation = ComfyGenetics::Generation.find_by(id: previous_generation_id_for_rollback)

        if experiment_to_revert && previous_generation
          experiment_to_revert.current_generation = previous_generation
          experiment_to_revert.save
        end

        if previous_generation && original_organism_fitness_values_for_rollback.present?
          # TODO: ComfyGenetics::Organism
          ComfyGenetics::Organism.where(id: original_organism_fitness_values_for_rollback.keys).each do |org|
            org.update(fitness: original_organism_fitness_values_for_rollback[org.id])
          end
        end

        newly_created_generation.destroy if newly_created_generation&.persisted?

        context.new_generation = nil
      end
    end
  end
end
