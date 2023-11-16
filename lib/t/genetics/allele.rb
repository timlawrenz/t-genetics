# frozen_string_literal: true

module T
  module Genetics
    class Allele
      def initialize(name, mutate:, crossover:, chromosome:)
        @name = name
        @mutate_function = mutate
        @crossover_class = crossover
        @chromosome = chromosome
      end

      def mutate!(probability: T::Genetics::MUTATION_RATE)
        return unless rand < probability

        mutation_result = if @mutate_function.is_a?(Symbol)
                            @chromosome.send(@mutate_function)
                          end

        @chromosome.send("#{@name}=", mutation_result)
      end
    end
  end
end
