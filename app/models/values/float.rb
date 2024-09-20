# frozen_string_literal: true

module Values
  class Float < ApplicationRecord
    self.table_name = :float_values
    include Valuable

    def data
      val = attributes['data']
      return 0 if val.nil?

      val
    end

    def random
      inheritable = allele.inheritable
      rand(inheritable.minimum..inheritable.maximum)
    end
  end
end
