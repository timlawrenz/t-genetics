# frozen_string_literal: true

module Organisms
  class Crossover < ApplicationCommand
    requires :organisms

    def call
      organisms.first.allele.each do |allele|
        values = organisms.map(&:values).flatten.select { |value| value.name == allele.name }
        allele.crossover_algorithm.call(values:)
      end
    end
  end
end
