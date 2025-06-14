# frozen_string_literal: true

module ComfyGenetics
  module Generations
    class Pick < GLCommand::Callable # TODO: GLCommand
      requires generation: Generation # TODO: ComfyGenetics::Generation
      returns :organism # TODO: ComfyGenetics::Organism

      def call
        # TODO: ComfyGenetics::Generations::Fitness, ComfyGenetics::Generation
        total_fitness = Generations::Fitness.call(generation:).total_fitness
        rand_selection = rand(total_fitness)

        total = 0
        # TODO: ComfyGenetics::Generation
        generation.organisms.with_fitness.each do |orga|
          context.organism = orga
          total += orga.fitness
          break if total > rand_selection
        end
      end
    end
  end
end
