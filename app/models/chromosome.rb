# frozen_string_literal: true

class Chromosome < ApplicationRecord
  validates :name, presence: true
  has_many :alleles, dependent: :destroy
  has_many :generations, dependent: :destroy
end
