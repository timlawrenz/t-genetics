# frozen_string_literal: true

class Relationship < ApplicationRecord
  belongs_to :parent, class_name: 'Chromosome'
  belongs_to :child, class_name: 'Chromosome'
end
