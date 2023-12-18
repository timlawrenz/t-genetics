class Organism < ApplicationRecord
  belongs_to :generation
  has_many :values, dependent: :destroy

  def to_hsh
    values.each_with_object({}) do |value, result|
      result[value.allele.name] = value.data
    end
  end
end
