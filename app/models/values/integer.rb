# frozen_string_literal: true

module Values
  class Integer < ApplicationRecord
    self.table_name = :integer_values
    include Valuable

    def random
      inheritable = allele.inheritable
      rand(inheritable.minimum..inheritable.maximum)
    end
  end
end
