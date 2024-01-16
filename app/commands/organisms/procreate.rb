# frozen_string_literal: true

module Organisms
  class Procreate < ApplicationCommand
    requires :parents

    def call
      context.children = parents.map(&:dolly_clone)
      Organisms::Crossover.call(organisms: context.children) if rand < CROSS_OVER_RATE
    end
  end
end
