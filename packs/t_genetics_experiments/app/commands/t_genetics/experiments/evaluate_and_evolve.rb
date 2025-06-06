# frozen_string_literal: true

module TGenetics
  module Experiments
    # Calculates fitness for organisms in an experiment's current generation
    # based on their performance logs and then triggers the evolution of a new generation.
    class EvaluateAndEvolve < GLCommand::Callable
      requires :experiment # Instance of TGenetics::Experiment

      def call
        ActiveRecord::Base.transaction do
          current_generation = experiment.current_generation
          organisms_to_evaluate = current_generation.organisms

          # 1. Calculate and update fitness for each organism
          organisms_to_evaluate.each do |organism|
            # Fetch relevant performance logs for this organism within this experiment.
            # Assumes PerformanceLog has experiment_id and organism_id.
            # For MVP, we consider all logs for the organism in this experiment.
            # Refinement: PerformanceLog could store generation_id to scope logs more precisely.
            relevant_logs = PerformanceLog.where(
              experiment_id: experiment.id,
              organism_id: organism.id
            ).where.not(fitness_input_value: nil)

            calculated_fitness = 0.0 # Default fitness
            calculated_fitness = relevant_logs.average(:fitness_input_value) if relevant_logs.any?

            organism.update!(fitness: calculated_fitness)
          end

          # Reload current_generation to ensure it has the updated fitness values on its organisms
          # if Generations::New relies on these being immediately queryable.
          current_generation.reload

          # 2. Create the next generation record
          new_iteration_number = current_generation.iteration + 1
          offspring_generation = Generation.create!(
            chromosome: experiment.chromosome, # Assumes experiment.chromosome is correct
            iteration: new_iteration_number
          )

          # 3. Populate the next generation using the core GA command
          # Determine organism_count for the new generation.
          # Defaulting to the same count as the parent generation.
          organism_count_for_new_generation = organisms_to_evaluate.count

          # Ensure organism_count is sensible if organisms_to_evaluate is empty.
          # Generations::New might have its own defaults or minimums.
          # The existing Generations::New command in the codebase allows :organism_count.
          Generations::New.call!(
            parent_generation: current_generation,
            offspring_generation: offspring_generation,
            organism_count: organism_count_for_new_generation
          )

          # 4. Update the experiment to point to the new generation
          experiment.update!(current_generation_id: offspring_generation.id)

          # 5. Optionally, update experiment status (example)
          # experiment.update!(status: 'active') # Or based on some logic/configuration
        end
      end

      # Rollback:
      # GLCommand ensures that if `call` raises an exception, any `rollback` methods
      # of previously successful commands in a chain would be called.
      # The `ActiveRecord::Base.transaction` block ensures that all database changes within
      # this command (Organism updates, Generation creation, Experiment update) are atomic.
      # If `Generations::New.call!` fails and raises an exception, the transaction will roll back.
    end
  end
end
