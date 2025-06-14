# frozen_string_literal: true

module ComfyGenetics
  module Experiments
    class RecordOutcome < GLCommand::Callable # TODO: GLCommand
      requires performance_log: ComfyGenetics::PerformanceLog
      requires :fitness_input_value, type: Float
      allows :outcome_metrics

      attr_accessor :original_fitness_input_value,
                    :original_outcome_metrics,
                    :original_outcome_recorded_at

      def call
        log = context.performance_log

        self.original_fitness_input_value = log.fitness_input_value
        self.original_outcome_metrics = log.outcome_metrics
        self.original_outcome_recorded_at = log.outcome_recorded_at

        attributes_to_update = {
          fitness_input_value: context.fitness_input_value,
          outcome_recorded_at: Time.current
        }
        attributes_to_update[:outcome_metrics] = context.outcome_metrics if context.outcome_metrics.present?

        unless log.update(attributes_to_update)
          fail_command!(errors: log.errors)
        end
      end

      def rollback
        return unless context.performance_log&.persisted?

        context.performance_log.update(
          fitness_input_value: original_fitness_input_value,
          outcome_metrics: original_outcome_metrics,
          outcome_recorded_at: original_outcome_recorded_at
        )
      end
    end
  end
end
