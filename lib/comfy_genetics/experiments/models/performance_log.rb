# frozen_string_literal: true

module ComfyGenetics
  class PerformanceLog < ComfyGenetics::ApplicationRecord
    belongs_to :experiment, class_name: 'ComfyGenetics::Experiment'
    belongs_to :organism, class_name: 'ComfyGenetics::Organism'

    validates :experiment, presence: true
    validates :organism, presence: true
    validates :suggested_at, presence: true
  end
end
