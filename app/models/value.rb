# frozen_string_literal: true

class Value < ApplicationRecord
  belongs_to :organism
  belongs_to :allele

  delegated_type :valuable, types: ['Value::Float', 'Value::Boolean', 'Value::Integer']
  delegate :data, to: :valuable
  delegate :data=, to: :valuable
  delegate :random, to: :valuable
  delegate :mutate!, to: :valuable

  scope :with_allele, -> { joins(:allele) }
  scope :by_name, ->(name) { with_allele.where(allele: { name: name }) }

  def self.new_from(allele)
    valuable_type = "Values::#{allele.type}".constantize
    new(allele:, valuable: valuable_type.new)
  end

  def to_s
    "#{allele.name}: #{valuable.data}"
  end
end
