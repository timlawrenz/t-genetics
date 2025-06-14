# frozen_string_literal: true

module ComfyGenetics
  module Generations
    class Fitness < GLCommand::Callable # TODO: GLCommand might need namespacing or be a different gem
      requires generation: Generation # TODO: ComfyGenetics::Generation
      returns average_fitness: Float,
              total_fitness: Float

      def call
        context.total_fitness = organisms_with_fitness.sum(&:fitness)
        context.average_fitness = if organisms_with_fitness.count.zero?
                                    nil
                                  else
                                    context.total_fitness / organisms_with_fitness.count
                                  end
      end

      private

      def organisms_with_fitness
        @organisms_with_fitness ||= generation.organisms.with_fitness # TODO: ComfyGenetics::Generation
      end
    end
  end
end
