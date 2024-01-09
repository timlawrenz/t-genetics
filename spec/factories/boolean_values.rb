# frozen_string_literal: true

FactoryBot.define do
  factory :boolean_value, class: 'Values::Boolean' do
    value
    data { true }
  end
end
