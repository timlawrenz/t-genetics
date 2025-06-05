# frozen_string_literal: true

module Organisms
  class Clone < GLCommand::Callable
    requires organism: Organism,
             target_generation: Generation
    returns dolly_clone: Organism

    def call
      create_result = Organisms::Create.call(generation: context.target_generation)
      context.dolly_clone = create_result.organism
      context.organism.values.each do |value| # rubocop:disable Style/HashEachMethods
        context.dolly_clone.set_value(value.name, value.data)
      end
    end
  end
end
