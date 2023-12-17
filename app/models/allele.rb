# frozen_string_literal: true

class Allele < ApplicationRecord
  validates :name, presence: true
  validates :inheritable, presence: true

  belongs_to :chromosome
  delegated_type :inheritable, types: ['Alleles::Float', 'Alleles::Boolean']
end
