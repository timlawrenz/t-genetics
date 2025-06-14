# frozen_string_literal: true

module ComfyGenetics
  class Organism < ComfyGenetics::ApplicationRecord
    belongs_to :generation # TODO: ComfyGenetics::Generation
    has_one :chromosome, through: :generation # TODO: ComfyGenetics::Chromosome
    has_many :values, dependent: :destroy # TODO: ComfyGenetics::Value

    scope :with_fitness, -> { where.not(fitness: nil) }

    def mutate!(probability: MUTATION_RATE) # TODO: Define MUTATION_RATE or ensure it's available
      values.each { |value| value.mutate! if rand <= probability } # TODO: ComfyGenetics::Value
    end

    def set_value(name, value)
      Organisms::SetValue.call(organism: self, name:, value:) # TODO: ComfyGenetics::Organisms::SetValue
    end

    def dolly_clone
      Organisms::Clone.call(organism: self).clone # TODO: ComfyGenetics::Organisms::Clone
    end

    def to_hsh
      values.reload.includes(:allele).sort_by(&:name).each_with_object({}) do |value, result| # TODO: ComfyGenetics::Value, ComfyGenetics::Allele
        result[value.allele.name.to_sym] = value.data
      end
    end
  end
end
