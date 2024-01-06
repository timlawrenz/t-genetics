# frozen_string_literal: true

module Organisms
  class SetValue < ApplicationCommand
    requires :organism
    requires :name
    requires :value

    def call
      organism
        .values
        .by_name(name)
        .first
        .valuable
        .update(data: value)
    end
  end
end
