# frozen_string_literal: true

module ComfyGenetics
  module Organisms
    class Create < GLCommand::Callable # TODO: GLCommand
      requires generation: Generation # TODO: ComfyGenetics::Generation
      returns organism: Organism # TODO: ComfyGenetics::Organism

      def call
        context.organism = generation.organisms.create # TODO: ComfyGenetics::Generation
        # TODO: ComfyGenetics::Generation, ComfyGenetics::Chromosome, ComfyGenetics::Allele
        context.generation.chromosome.alleles.each do |allele|
          # TODO: ComfyGenetics::Organism, ComfyGenetics::Value, ComfyGenetics::Allele
          context.organism.values << Value.new_from(allele)
        end
      end

      def rollback
        # Ensure context.organism exists and is persisted before attempting to destroy
        # TODO: ComfyGenetics::Organism
        context.organism&.destroy if context.organism&.persisted?
      end
    end
  end
end
