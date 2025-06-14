# frozen_string_literal: true

module ComfyGenetics
  module Values
    class Integer < ComfyGenetics::ApplicationRecord
      self.table_name = :integer_values
      include Valuable # TODO: ComfyGenetics::Valuable

      def random
        inheritable = allele.inheritable # TODO: ComfyGenetics::Allele
        rand(inheritable.minimum..inheritable.maximum)
      end
    end
  end
end
