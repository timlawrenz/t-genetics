# frozen_string_literal: true

module Organisms
  class Proreate < ApplicationCommand
    requires :organism

    def call
      context.clone = Organisms::Create.call(generation: organism.generation)
      context.organism.values.each do |value|
        context.clone.set_data(value.name, value.data)
      end
    end
  end
end
