# frozen_string_literal: true

module ComfyGenetics
  module Alleles
    class Float < ComfyGenetics::ApplicationRecord
      self.table_name = :float_alleles

      include Inheritable # TODO: May need ComfyGenetics::Inheritable or similar

      def to_s
        "minimum: #{minimum}, maximum: #{maximum}"
      end
    end
  end
end
