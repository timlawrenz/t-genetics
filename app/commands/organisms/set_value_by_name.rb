module Organisms
  class SetValueByName < ApplicationCommand
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
