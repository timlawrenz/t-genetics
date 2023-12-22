# frozen_string_literal: true

class FloatValue < ApplicationRecord
  include Valuable

  def to_s
    data
  end
end
