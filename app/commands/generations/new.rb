# frozen_string_literal: true

module Generations
  class New < GLCommand::Callable
    requires :parent_generation,
             :offspring_generation
    allows :organism_count

    def call
      set_defaults
      while offspring_generation.organisms.count < organism_count
        children = Organisms::Procreate.call(parents:).children
        children.each { |child| child.update(generation: offspring_generation) }
      end
    end

    private

    def set_defaults
      context.organism_count ||= 20
    end

    def parents
      result = []
      2.times do
        pick_result = Generations::Pick.call(generation: parent_generation)
        result << pick_result.organism if pick_result.success?
      end

      result
    end
  end
end
