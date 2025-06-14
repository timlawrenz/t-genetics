# frozen_string_literal: true

module ComfyGenetics
  class Value < ComfyGenetics::ApplicationRecord
    belongs_to :organism # TODO: ComfyGenetics::Organism
    belongs_to :allele # TODO: ComfyGenetics::Allele

    delegated_type :valuable, types: ['Values::Float', 'Values::Boolean', 'Values::Integer'] # TODO: ComfyGenetics::Values::...
    delegate :data, :data=, to: :valuable
    delegate :mutate, :mutate!, to: :valuable
    delegate :name, to: :allele # TODO: ComfyGenetics::Allele

    scope :with_allele, -> { joins(:allele) } # TODO: ComfyGenetics::Allele
    scope :by_name, ->(name) { with_allele.where(allele: { name: }) } # TODO: ComfyGenetics::Allele

    def self.new_from(allele, options = {}) # TODO: ComfyGenetics::Allele
      valuable_type = "ComfyGenetics::Values::#{allele.type}".constantize # Adjusted this one
      new(options.merge(allele:, valuable: valuable_type.new)) # TODO: ComfyGenetics::Allele
    end

    def self.create_from(allele, options = {}) # TODO: ComfyGenetics::Allele
      v = new_from(allele, options) # TODO: ComfyGenetics::Allele
      v.save
      v
    end

    def to_s
      "#{allele.name}: #{valuable.data}" # TODO: ComfyGenetics::Allele
    end
  end
end
