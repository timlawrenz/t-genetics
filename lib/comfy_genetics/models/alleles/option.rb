# frozen_string_literal: true

module ComfyGenetics
  module Alleles
    class Option < ComfyGenetics::ApplicationRecord
      self.table_name = :option_alleles
      include Inheritable # TODO: May need ComfyGenetics::Inheritable or similar

      def crossover_algorithm
        Organisms::Crossovers::Random # TODO: May need ComfyGenetics::Organisms::Crossovers::Random
      end

      def to_s
        "choices: #{choices}"
      end
    end
  end
end
