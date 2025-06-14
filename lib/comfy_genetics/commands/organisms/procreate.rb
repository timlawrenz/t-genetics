# frozen_string_literal: true

module ComfyGenetics
  module Organisms
    class Procreate < GLCommand::Callable # TODO: GLCommand
      requires :parents, # TODO: ComfyGenetics::Organism (presumably a collection)
               target_generation: Generation # TODO: ComfyGenetics::Generation
      returns :children # TODO: ComfyGenetics::Organism (presumably a collection)

      def call
        errors.add(:parents, 'must be an array of two parents') unless parents.size == 2

        # TODO: ComfyGenetics::Organism, ComfyGenetics::Generation
        context.children = parents.map { |parent| parent.dolly_clone(target_generation: context.target_generation) }
        # TODO: ComfyGenetics::Organisms::Crossover
        Organisms::Crossover.call!(organisms: context.children)
        context.children.map(&:mutate!)
      end
    end
  end
end
