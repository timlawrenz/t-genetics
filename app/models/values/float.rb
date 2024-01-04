# frozen_string_literal: true

module Values
  class Float < ApplicationRecord
    self.table_name = :float_values
    delegate :allele, to: :value
    include Valuable

    def to_s
      data
    end

    def random
      inheritable = allele.inheritable
      rand(inheritable.minimum..inheritable.maximum)
    end

    def mutate!
      self.data = random
    end
  end
end
