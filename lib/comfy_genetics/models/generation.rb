# frozen_string_literal: true

module ComfyGenetics
  class Generation < ComfyGenetics::ApplicationRecord
    belongs_to :chromosome # TODO: ComfyGenetics::Chromosome
    has_many :organisms, dependent: :destroy # TODO: ComfyGenetics::Organism
    scope :latest, -> { order(iteration: :desc).first }
  end
end
