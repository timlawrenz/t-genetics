# frozen_string_literal: true

module ComfyGenetics
  module Organisms
    module Crossovers
      class Random < GLCommand::Callable # TODO: GLCommand
        requires :values # TODO: ComfyGenetics::Value (presumably a collection)

        def call
          # TODO: ComfyGenetics::Value
          values.each do |value|
            data = values.map(&:data).sample
            # TODO: ComfyGenetics::Organism (organism seems to be missing from requires)
            organism.set_value(value.name, data)
          end
        end
      end
    end
  end
end
