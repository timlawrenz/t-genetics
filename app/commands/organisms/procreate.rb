# frozen_string_literal: true

module Organisms
  class Proreate < ApplicationCommand
    requires :parents
    delegate :children, to: :context

    def call
      children = parents.map(&:clone)
      Organisms::Crossover.call(organisms: children) if rand < CROSS_OVER_RATE
    end
  end
end
