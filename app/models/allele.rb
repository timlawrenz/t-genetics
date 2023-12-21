# frozen_string_literal: true

class Allele < ApplicationRecord
  validates :name, presence: true

  delegated_type :inheritable, types: ['Alleles::Float', 'Alleles::Boolean', 'Alleles::Integer']

  belongs_to :chromosome

  def self.new_with_float(name:, minimum:, maximum:)
    new(name:, inheritable: Alleles::Float.create(minimum:, maximum:))
  end

  def self.new_with_integer(name:, minimum:, maximum:)
    new(name:, inheritable: Alleles::Integer.create(minimum:, maximum:))
  end

  def to_s
    "#{name}: [#{inheritable}]"
  end
end
