# frozen_string_literal: true

module ComfyGenetics
  module Experiments
    class Setup < GLCommand::Callable # TODO: GLCommand
      requires :external_entity
      requires chromosome: ComfyGenetics::Chromosome
      allows :experiment_configuration
      returns :experiment # TODO: ComfyGenetics::Experiment

      def call
        context.experiment_configuration ||= {}
        population_size = context.experiment_configuration.fetch(:population_size, 10)

        @generation = nil
        @experiment = nil

        unless context.chromosome.persisted?
          fail_command!(errors: { chromosome: ['must be a persisted Chromosome record'] })
          return
        end

        ActiveRecord::Base.transaction do
          # 1. Create Initial Generation
          # TODO: ComfyGenetics::Generation
          @generation = ComfyGenetics::Generation.new(chromosome: context.chromosome, iteration: 0)
          unless @generation.save
            fail_command!(errors: @generation.errors)
            raise ActiveRecord::Rollback
          end

          # 2. Populate Initial Generation with Organisms
          population_size.times do
            # TODO: ComfyGenetics::Organisms::Create
            create_organism_result = ComfyGenetics::Organisms::Create.call(generation: @generation)
            unless create_organism_result.success?
              errors.add(:base, "Failed to create organism for initial population.")
              errors.merge!(create_organism_result.errors)
              fail_command!(errors:)
              raise ActiveRecord::Rollback
            end
          end

          # 3. Create Experiment Record
          # TODO: ComfyGenetics::Experiment
          @experiment = ComfyGenetics::Experiment.new(
            external_entity: context.external_entity,
            chromosome: context.chromosome,
            current_generation: @generation,
            configuration: context.experiment_configuration
          )
          unless @experiment.save
            fail_command!(errors: @experiment.errors)
            raise ActiveRecord::Rollback
          end

          context.experiment = @experiment
        end
      rescue ActiveRecord::Rollback
        context.experiment = nil unless @experiment&.persisted?
      end

      def rollback
        return unless context.experiment&.persisted?

        experiment_to_rollback = context.experiment
        generation_to_rollback = experiment_to_rollback.current_generation

        experiment_to_rollback.destroy
        generation_to_rollback.destroy if generation_to_rollback&.persisted?
      end
    end
  end
end
