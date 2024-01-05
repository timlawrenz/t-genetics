# frozen_string_literal: true

module Values
  class Float < ApplicationRecord
    self.table_name = :float_values
    include Valuable
  end
end
