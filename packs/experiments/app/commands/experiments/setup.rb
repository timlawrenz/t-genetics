# frozen_string_literal: true

module Experiments
  class Setup < GLCommand::Callable
    requires :external_entity # Polymorphic ActiveRecord object
    requires chromosome: Chromosome # Existing, persisted Chromosome record
    allows :experiment_configuration # Hash, for Experiment.configuration. Defaults to {}.
                                     # Can include :population_size (defaults to 10).
    returns :experiment # The created Experiment record

    def call
      context.experiment_configuration ||= {}
      population_size = context.experiment_configuration.fetch(:population_size, 10) # Default population size

      # Instance variables to hold created records for potential access in rollback
      @generation = nil
      @experiment = nil

      # GLCommand checks type, but we also need to ensure it's persisted.
      unless context.chromosome.persisted?
        fail_command!(errors: { chromosome: ['must be a persisted Chromosome record'] })
        return # Early exit if chromosome is not persisted
      end

      ActiveRecord::Base.transaction do
        # 1. Create Initial Generation
        @generation = Generation.new(chromosome: context.chromosome, iteration: 0)
        unless @generation.save
          fail_command!(errors: @generation.errors)
          raise ActiveRecord::Rollback
        end

        # 2. Populate Initial Generation with Organisms
        population_size.times do
          create_organism_result = Organisms::Create.call(generation: @generation)
          unless create_organism_result.success?
            errors.add(:base, "Failed to create organism for initial population.")
            errors.merge!(create_organism_result.errors) # Propagate errors
            fail_command!(errors:)
            raise ActiveRecord::Rollback
          end
        end

        # 3. Create Experiment Record
        @experiment = Experiment.new(
          external_entity: context.external_entity,
          chromosome: context.chromosome,
          current_generation: @generation,
          configuration: context.experiment_configuration
          # Status will be set to 'pending' by AASM's initial state
        )
        unless @experiment.save
          fail_command!(errors: @experiment.errors)
          raise ActiveRecord::Rollback
        end

        context.experiment = @experiment
      end
    rescue ActiveRecord::Rollback
      # Transaction was rolled back. fail_command! should have been called.
      # Ensure context.experiment is not set if we bailed early.
      context.experiment = nil unless @experiment&.persisted?
      # Errors are already set by fail_command!
    end

    def rollback
      # This rollback is invoked if this command (Setup) succeeded,
      # but a subsequent command in a GLCommand::Chain failed.
      # It should undo the successfully persisted records from the `call` method.

      # Note: This rollback relies on `dependent: :destroy` being configured on:
      # - `Generation` for its `organisms`.
      # - `Organism` for its `values`.

      return unless context.experiment&.persisted?

      experiment_to_rollback = context.experiment
      # Retrieve associated generation directly from the experiment instance
      generation_to_rollback = experiment_to_rollback.current_generation

      experiment_to_rollback.destroy

      # If dependent: :destroy is correctly set up on Generation model,
      # destroying it will cascade to its Organisms.
      # The Chromosome is an input and should not be destroyed by this command's rollback.
      generation_to_rollback.destroy if generation_to_rollback&.persisted?
    end
  end
end
