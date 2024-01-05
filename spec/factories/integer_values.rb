# frozen_string_literal: true

FactoryBot.define do
  factory :integer_value, class: 'Values::Integer' do
    value
    data { 1 }
  end
end
