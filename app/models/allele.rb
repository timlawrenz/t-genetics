# frozen_string_literal: true

class Allele < ApplicationRecord
  validates :name, presence: true
  validates :inheritable, presence: true

  delegated_type :inheritable, types: ['Alleles::Float', 'Alleles::Boolean', 'Alleles::Integer']

  belongs_to :chromosome

  def to_s
    "#{name}, #{inheritable}"
  end
end
