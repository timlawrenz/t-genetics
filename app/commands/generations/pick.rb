# frozen_string_literal: true

module Generations
  class Pick < ApplicationCommand
    requires :generation
    delegate :organism, to: :context

    def call
      total_fitness = Generations::Fitness.call(generation:).total_fitness
      rand_selection = rand(total_fitness)

      total = 0
      generation.organisms.with_fitness.each do |orga|
        context.organism = orga
        total += orga.fitness
        break if total > rand_selection
      end
    end
  end
end
