# frozen_string_literal: true

module ComfyGenetics
  module Experiments
    class RequestSuggestion < GLCommand::Callable # TODO: GLCommand
      requires experiment: ComfyGenetics::Experiment
      returns :organism, :performance_log # TODO: ComfyGenetics::Organism, ComfyGenetics::PerformanceLog

      def call
        current_generation = context.experiment.current_generation
        unless current_generation
          fail_command!(errors: { experiment: ['does not have a current generation'] })
          return
        end

        organisms_in_generation = current_generation.organisms.includes(:performance_logs)
        if organisms_in_generation.empty?
          fail_command!(errors: { generation: ['current generation has no organisms'] })
          return
        end

        organisms_with_log_counts = organisms_in_generation.map do |org|
          # TODO: ComfyGenetics::PerformanceLog
          log_count = ComfyGenetics::PerformanceLog.where(experiment_id: context.experiment.id, organism_id: org.id).count
          { organism: org, count: log_count }
        end

        if organisms_with_log_counts.empty?
          fail_command!(errors: { generation: ["Could not process organisms for log counting"] })
          return
        end

        min_count = organisms_with_log_counts.map { |data| data[:count] }.min
        least_logged_organisms_data = organisms_with_log_counts.select { |data| data[:count] == min_count }
        selected_organism_data = least_logged_organisms_data.sample
        selected_organism = selected_organism_data[:organism]

        # TODO: ComfyGenetics::PerformanceLog
        @performance_log = ComfyGenetics::PerformanceLog.new(
          experiment: context.experiment,
          organism: selected_organism,
          suggested_at: Time.current
        )

        unless @performance_log.save
          fail_command!(errors: @performance_log.errors)
          return
        end

        context.organism = selected_organism
        context.performance_log = @performance_log
      end

      def rollback
        @performance_log.destroy if @performance_log&.persisted?
        context.performance_log = nil if @performance_log&.destroyed?
        context.organism = nil if @performance_log&.destroyed?
      end
    end
  end
end
