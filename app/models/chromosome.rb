# frozen_string_literal: true

class Chromosome < ApplicationRecord
  validates :name, presence: true
  has_many :alleles, dependent: :destroy
  has_many :generations, dependent: :destroy
  has_many :organisms, through: :generations

  def to_s
    "#<Chromosome id:#{id} name:#{name} alleles:[#{alleles.map(&:to_s).join(', ')}]>"
  end

  def allele_named?(name)
    alleles.by_name(name).present?
  end

  def respond_to_missing?(method_name, *_arguments, &)
    allele_named?(method_name)
  end

  def method_missing(method_name, *_arguments, &)
    return alleles.by_name(method_name) if allele_named?(method_name)

    super
  end
end
