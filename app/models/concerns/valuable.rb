# frozen_string_literal: true

module Valuable
  extend ActiveSupport::Concern

  included do
    has_one :value, as: :valuable, touch: true, dependent: :destroy
  end
end
