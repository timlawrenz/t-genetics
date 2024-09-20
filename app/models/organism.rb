# frozen_string_literal: true

class Organism < ApplicationRecord
  belongs_to :generation
  has_one :chromosome, through: :generation
  has_many :values, dependent: :destroy

  scope :with_fitness, -> { where.not(fitness: nil) }

  def mutate!(probability: MUTATION_RATE)
    values.each { |value| value.mutate! if rand <= probability }
  end

  def set_value(name, value)
    Organisms::SetValue.call(organism: self, name:, value:)
  end

  def dolly_clone
    Organisms::Clone.call(organism: self).clone
  end

  def to_hsh
    values.reload.includes(:allele).sort_by(&:name).each_with_object({}) do |value, result|
      result[value.allele.name.to_sym] = value.data
    end
  end
end
