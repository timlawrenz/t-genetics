# frozen_string_literal: true

FactoryBot.define do
  factory :allele do
    name { 'MyString' }
    chromosome
  end
end

FactoryBot.define do
  factory :float_allele do
    value { 0.3 }
  end
end
