# frozen_string_literal: true

module Values
  class Option < ApplicationRecord
    self.table_name = :option_values
    include Valuable

    def random
      allele.inheritable.choices.sample
    end
  end
end
