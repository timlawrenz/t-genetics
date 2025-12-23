# frozen_string_literal: true

FactoryBot.define do
  factory :allele do
    name { 'Name' }
    chromosome
    inheritable { Alleles::Float.create }
  end
end

FactoryBot.define do
  factory :'Alleles::Float' do
    allele
  end
end
