# frozen_string_literal: true

class Chromosome < ApplicationRecord
  has_many :allele, dependent: :destroy
end
