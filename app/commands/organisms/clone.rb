# frozen_string_literal: true

module Organisms
  class Clone < GLCommand::Callable
    requires organism: Organism

    def call
      create_result = Organisms::Create.call(generation: organism.generation)
      context.clone = create_result.organism
      context.organism.values.each do |value| # rubocop:disable Style/HashEachMethods
        context.clone.set_value(value.name, value.data)
      end
    end
  end
end
