# frozen_string_literal: true

module ComfyGenetics
  module Organisms
    module Crossovers
      class Average < GLCommand::Callable # TODO: GLCommand
        requires :values # TODO: ComfyGenetics::Value (presumably a collection)

        def call
          avg = values.map(&:data).reduce(:+) / values.size.to_f
          # TODO: ComfyGenetics::Value, ComfyGenetics::Organism (organism seems to be missing from requires)
          values.each { |value| organism.set_value(value.name, avg) }
        end
      end
    end
  end
end
