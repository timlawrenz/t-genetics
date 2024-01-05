# frozen_string_literal: true

module Values
  class Integer < ApplicationRecord
    self.table_name = :integer_values
    include Valuable
  end
end
