# frozen_string_literal: true

FactoryBot.define do
  factory :generation do
    chromosome
    iteration { 1 }
  end
end
