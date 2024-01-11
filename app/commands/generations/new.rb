# frozen_string_literal: true

module Generations
  class New < ApplicationCommand
    requires :parent_generation
    requires :offspring_generation
    allows :organism_count

    before :set_defaults

    def call
      organisms = parent_generation.organisms
      while organisms.count < organism_count do
        parents = []
      end
    end

    private

    def set_defaults
      context.organism_count ||= 20
    end
  end
end
