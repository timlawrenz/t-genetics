# frozen_string_literal: true

FactoryBot.define do
  factory :organism do
    generation
    fitness { 1 }
  end
end
