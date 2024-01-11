# frozen_string_literal: true

module Generations
  class Pick < ApplicationCommand
    requires :generation

    def call
      rand_selection = rand(total_fitness)

      total = 0
      generation.chromosomes.each do |chr|
        context.chromosome = chr
        total += chr.fitness
        break if total > rand_selection
      end

      context.fail! if context.chromosome.blank?
    end
  end

  private

  def total_fitness
    @total_fitness ||= Generations::Fitness.call(generation:).total_fitness
  end
end
