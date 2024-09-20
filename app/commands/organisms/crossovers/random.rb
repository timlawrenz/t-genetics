# frozen_string_literal: true

module Organisms
  module Crossovers
    class Random < GLCommand::Callable
      requires :values

      def call
        values.each do |value|
          data = values.map(&:data).sample
          organism.set_value(value.name, data)
        end
      end
    end
  end
end
