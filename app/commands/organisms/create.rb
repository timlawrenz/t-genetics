# frozen_string_literal: true

module Organisms
  class Create < ApplicationCommand
    requires :generation

    def call
      context.organism = generation.organisms.create
      context.generation.chromosome.alleles.each do |allele|
        context.organism.values << Value.new_from(allele)
      end
    end
  end
end
