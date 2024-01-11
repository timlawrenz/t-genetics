# frozen_string_literal: true

class Value < ApplicationRecord
  belongs_to :organism
  belongs_to :allele

  delegated_type :valuable, types: ['Value::Float', 'Value::Boolean', 'Value::Integer']
  delegate :data, :data=, to: :valuable
  delegate :mutate, :mutate!, to: :valuable
  delegate :name, to: :allele

  scope :with_allele, -> { joins(:allele) }
  scope :by_name, ->(name) { with_allele.where(allele: { name: }) }

  def self.new_from(allele, options = {})
    valuable_type = "Values::#{allele.type}".constantize
    new(options.merge(allele:, valuable: valuable_type.new))
  end

  def self.create_from(allele, options = {})
    v = new_from(allele, options)
    v.save
    v
  end

  def to_s
    "#{allele.name}: #{valuable.data}"
  end
end
