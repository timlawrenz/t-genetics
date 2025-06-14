# frozen_string_literal: true

module ComfyGenetics
  module Values
    class Float < ComfyGenetics::ApplicationRecord
      self.table_name = :float_values
      include Valuable # TODO: ComfyGenetics::Valuable

      def data
        val = attributes['data']
        return 0 if val.nil?

        val
      end

      def random
        inheritable = allele.inheritable # TODO: ComfyGenetics::Allele
        rand(inheritable.minimum..inheritable.maximum)
      end
    end
  end
end
