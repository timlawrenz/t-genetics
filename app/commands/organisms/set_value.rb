# frozen_string_literal: true

module Organisms
  class SetValue < GLCommand::Callable
    requires :organism,
             :name,
             :value

    def call
      organism
        .values
        .by_name(name)
        .first
        .valuable
        .reload
        .update(data: value)
    end
  end
end
