# frozen_string_literal: true

module Organisms
  class Procreate < GLCommand::Callable
    requires :parents

    def call
      context.children = parents.map(&:dolly_clone)
      Organisms::Crossover.call(organisms: context.children)
      context.children.map(&:mutate!)
    end
  end
end
