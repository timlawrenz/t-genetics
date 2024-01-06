# frozen_string_literal: true

module Values
  class Boolean < ApplicationRecord
    self.table_name = :boolean_values
    include Valuable

    def random
      [false, true].sample
    end
  end
end
