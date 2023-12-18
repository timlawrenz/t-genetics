# frozen_string_literal: true

module Alleles
  class Float < ApplicationRecord
    self.table_name = :float_alleles

    include Inheritable

    def to_s
      "minimum: #{minimum}, maximum: #{maximum}"
    end
  end
end
