# frozen_string_literal: true

class Chromosome < ApplicationRecord
  validates :name, presence: true
  has_many :alleles, dependent: :destroy
  has_many :generations, dependent: :destroy
  has_many :organisms, through: :generations

  def to_s
    "#<Chromosome id:#{id} name:#{name} alleles:[#{alleles.map(&:to_s).join(', ')}]>"
  end
end
