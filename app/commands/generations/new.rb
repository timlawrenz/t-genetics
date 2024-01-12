# frozen_string_literal: true

module Generations
  class New < ApplicationCommand
    requires :parent_generation
    requires :offspring_generation
    allows :organism_count

    before :set_defaults

    def call
      organisms = parent_generation.organisms
      while organisms.count < organism_count
        parents = []
        2.times { parents << Generations::Pick.call(generation: parent_generation) }
        children = Generations::Proreate.call(parents:).children
        children.each { |child| child.update(generation: offspring_generation) }
      end
    end

    private

    def set_defaults
      context.organism_count ||= 20
    end
  end
end
