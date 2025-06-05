# frozen_string_literal: true

module Organisms
  class Procreate < GLCommand::Callable
    requires :parents
    returns :children

    def call
      errors.add(:parents, 'must be an array of two parents') unless parents.size == 2

      context.children = parents.map(&:dolly_clone)
      Organisms::Crossover.call!(organisms: context.children)
      context.children.map(&:mutate!)
    end
  end
end
