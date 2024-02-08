# frozen_string_literal: true

class Chromosome < ApplicationRecord
  validates :name, presence: true
  has_many :alleles, dependent: :destroy
  has_many :generations, dependent: :destroy
  has_many :organisms, through: :generations

  after_initialize do
    alleles.each do |allele|
      self.class.send(:define_method, allele.name) { allele }
    end
  end

  def to_s
    "#<Chromosome id:#{id} name:#{name} alleles:[#{alleles.map(&:to_s).sort.join(', ')}]>"
  end
end
