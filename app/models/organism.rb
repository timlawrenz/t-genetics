# frozen_string_literal: true

class Organism < ApplicationRecord
  belongs_to :generation
  has_many :values, dependent: :destroy

  def self.factory(generation:)
    result = create(generation:)
    generation.chromosome.alleles.each do |allele|
      result.values << Value.new_from(allele)
    end
    result
  end

  def to_hsh
    values.each_with_object({}) do |value, result|
      result[value.allele.name.to_sym] = value.data
    end
  end
end
