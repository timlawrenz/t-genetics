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

        @chromosome.send("#{@name}=", @chromosome.send(@mutate_function))
        @chromosome.save
      end
    end
  end
end
