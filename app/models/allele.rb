# frozen_string_literal: true

class Allele < ApplicationRecord
  validates :name, presence: true

  delegated_type :inheritable, types: ['Alleles::Float', 'Alleles::Boolean', 'Alleles::Integer']
  delegate :minimum, :maximum, to: :inheritable
  scope :by_name, ->(name) { find_by(name:) }

  belongs_to :chromosome

  def self.new_with_float(name:, minimum:, maximum:)
    new(name:, inheritable: Alleles::Float.create(minimum:, maximum:))
  end

  def self.new_with_integer(name:, minimum:, maximum:)
    new(name:, inheritable: Alleles::Integer.create(minimum:, maximum:))
  end

  def self.new_with_boolean(name:)
    new(name:, inheritable: Alleles::Boolean.create)
  end

  def crossover_algorithm
    Organismsm::Crossovers::Average
  end

  def type
    inheritable.class.to_s.split('::').last
  end

  def to_s
    "#{name}: [#{inheritable}]"
  end
end
