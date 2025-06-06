# frozen_string_literal: true

module Experiments
  class RequestSuggestion < GLCommand::Callable
    requires experiment: Experiment
    returns :organism, :performance_log

    def call
      current_generation = context.experiment.current_generation
      unless current_generation
        fail_command!(errors: { experiment: ['does not have a current generation'] })
        return
      end

      organisms_in_generation = current_generation.organisms.includes(:performance_logs) # Eager load to potentially optimize
      if organisms_in_generation.empty?
        fail_command!(errors: { generation: ['current generation has no organisms'] })
        return
      end

      # MVP: Select organism with the fewest PerformanceLog entries for this experiment.
      # This is an N+1 query pattern within the loop if not careful,
      # but for MVP, we map and then count.
      # A more optimized query could be `organisms_in_generation.min_by { |org| org.performance_logs.where(experiment_id: context.experiment.id).count }`
      # but that's still N+1.
      # Let's do a slightly more direct N+1 for clarity in MVP:
      organisms_with_log_counts = organisms_in_generation.map do |org|
        # Count logs specific to this organism AND this experiment
        log_count = PerformanceLog.where(experiment_id: context.experiment.id, organism_id: org.id).count
        { organism: org, count: log_count }
      end

      # This should not happen if organisms_in_generation is not empty, but as a safeguard:
      if organisms_with_log_counts.empty?
        fail_command!(errors: { generation: ["Could not process organisms for log counting"] })
        return
      end
      
      # Find the minimum count
      min_count = organisms_with_log_counts.map { |data| data[:count] }.min
      
      # Get all organisms with that minimum count
      least_logged_organisms_data = organisms_with_log_counts.select { |data| data[:count] == min_count }
      
      # Select one randomly from the least logged (handles ties)
      # .sample can return nil if the array is empty, but we've guarded against that.
      selected_organism_data = least_logged_organisms_data.sample
      selected_organism = selected_organism_data[:organism]

      @performance_log = PerformanceLog.new(
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
      # This rollback is invoked if this command (RequestSuggestion) succeeded,
      # but a subsequent command in a GLCommand::Chain failed.
      # It should undo the created PerformanceLog.
      @performance_log.destroy if @performance_log&.persisted?
      # Also clear from context if it was set
      context.performance_log = nil if @performance_log&.destroyed?
      context.organism = nil if @performance_log&.destroyed? # Organism wasn't created by this command
    end
  end
end
