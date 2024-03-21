# frozen_string_literal: true

module Alleles
  class Option < ApplicationRecord
    self.table_name = :option_alleles
    include Inheritable

    def to_s
      "choices: #{choices}"
    end
  end
end
