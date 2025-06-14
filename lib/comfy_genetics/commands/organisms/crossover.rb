# frozen_string_literal: true

module ComfyGenetics
  module Organisms
    class Crossover < GLCommand::Callable # TODO: GLCommand
      requires :organisms # TODO: ComfyGenetics::Organism (presumably a collection)

      def call
        # TODO: CROSS_OVER_RATE needs to be defined or available
        # TODO: ComfyGenetics::Organism, ComfyGenetics::Chromosome, ComfyGenetics::Allele
        organisms.first.chromosome.alleles.each do |allele|
          next unless rand < CROSS_OVER_RATE

          Rails.logger.debug { "Crossover of #{allele.name}" }
          # TODO: ComfyGenetics::Allele, ComfyGenetics::Value, ComfyGenetics::Organism
          values = allele.values.where(organism: organisms)

          o1 = values.first.organism
          o2 = values.last.organism
          values.first.update(organism: o2)
          values.last.update(organism: o1)
        end
      end
    end
  end
end
