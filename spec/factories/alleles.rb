# frozen_string_literal: true

FactoryBot.define do
  factory :allele do
    name { 'MyString' }
    chromosome
    inheritable { FactoryBot.create(:float_allele) }
  end
end

FactoryBot.define do
  factory :float_allele do
  end
end
