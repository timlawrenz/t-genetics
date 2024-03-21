# frozen_string_literal: true

module Organisms
  class Clone < ApplicationCommand
    requires :organism

    def call
      create_result = Organisms::Create.call(generation: organism.generation)
      context.clone = create_result.organism
      context.organism.each_value do |value|
        context.clone.set_value(value.name, value.data)
      end
    end
  end
end
