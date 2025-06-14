# frozen_string_literal: true

module ComfyGenetics
  module Values
    class Boolean < ComfyGenetics::ApplicationRecord
      self.table_name = :boolean_values
      include Valuable # TODO: ComfyGenetics::Valuable

      def random
        [false, true].sample
      end
    end
  end
end
