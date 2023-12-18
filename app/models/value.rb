class Value < ApplicationRecord
  belongs_to :organism
  belongs_to :allele

  delegated_type :valuable, types: ['Value::Float', 'Value::Boolean', 'Value::Integer']
  delegate :data, to: :valuable

  def to_s
    "#{allele.name}: #{valuable.to_s}"
  end
end
