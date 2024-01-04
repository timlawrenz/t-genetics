# frozen_string_literal: true

class Generation < ApplicationRecord
  belongs_to :chromosome
  has_many :organisms, dependent: :destroy

  scope :latest, -> { order(iteration: :desc).first }

  def total_fitness
    @total_fitness ||= organisms.with_fitness.sum(&:fitness)
  end

  def organisms_with_fitness
    @organisms_with_fitness ||= organisms.with_fitness
  end

  def average_fitness
    return nil if organisms_with_fitness.count.zero?

    total_fitness / organisms_with_fitness.count
  end
end
