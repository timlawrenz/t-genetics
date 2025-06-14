# frozen_string_literal: true

module ComfyGenetics
  module Values
    class Option < ComfyGenetics::ApplicationRecord
      self.table_name = :option_values
      include Valuable # TODO: ComfyGenetics::Valuable

      def random
        allele.inheritable.choices.sample # TODO: ComfyGenetics::Allele
      end
    end
  end
end
