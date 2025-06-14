# frozen_string_literal: true

module ComfyGenetics
  module Generations
    class New < GLCommand::Callable # TODO: GLCommand
      requires :parent_generation, # TODO: ComfyGenetics::Generation
               :offspring_generation # TODO: ComfyGenetics::Generation
      allows :organism_count

      def call
        set_defaults
        while offspring_generation.organisms.count < organism_count # TODO: ComfyGenetics::Generation
          children = Organisms::Procreate.call(parents:).children # TODO: ComfyGenetics::Organisms::Procreate
          children.each { |child| child.update(generation: offspring_generation) } # TODO: ComfyGenetics::Generation
        end
      end

      private

      def set_defaults
        context.organism_count ||= 20
      end

      def parents
        result = []
        2.times do
          pick_result = Generations::Pick.call(generation: parent_generation) # TODO: ComfyGenetics::Generations::Pick, ComfyGenetics::Generation
          result << pick_result.organism if pick_result.success?
        end

        result
      end
    end
  end
end
