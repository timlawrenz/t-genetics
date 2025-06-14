# frozen_string_literal: true

module ComfyGenetics
  module Alleles
    class Boolean < ComfyGenetics::ApplicationRecord
      self.table_name = :boolean_alleles

      include Inheritable # TODO: May need ComfyGenetics::Inheritable or similar

      def crossover_algorithm
        Organisms::Crossovers::Random # TODO: May need ComfyGenetics::Organisms::Crossovers::Random
      end

      def to_s
        'boolean'
      end
    end
  end
end
