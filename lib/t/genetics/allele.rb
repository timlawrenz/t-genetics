# frozen_string_literal: true

module T
  module Genetics
    class Allele
      def initialize(name, mutate:, crossover:)
        @name = name
        @mutate_function = mutate
        @crossover_class = crossover
      end

      def mutate!(probability: T::Genetics::MUTATION_RATE)
      end
    end
  end
end
