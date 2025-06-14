# frozen_string_literal: true

module ComfyGenetics
  class Relationship < ComfyGenetics::ApplicationRecord
    belongs_to :parent, class_name: 'ComfyGenetics::Chromosome'
    belongs_to :child, class_name: 'ComfyGenetics::Chromosome'
  end
end
