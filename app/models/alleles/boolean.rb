# frozen_string_literal: true

module Alleles
  class Boolean < ApplicationRecord
    self.table_name = :boolean_alleles

    include Inheritable

    def to_s
      'boolean'
    end
  end
end
