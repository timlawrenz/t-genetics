class IntegerValue < ApplicationRecord
  include Valuable

  def to_s
    data
  end
end
