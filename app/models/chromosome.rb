# frozen_string_literal: true

class Chromosome < ApplicationRecord
  has_many :alleles, dependent: :destroy
end
