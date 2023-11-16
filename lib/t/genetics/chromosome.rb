# frozen_string_literal: true

module T
  module Genetics
    module Chromosome
      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end

      module ClassMethods
        def allele(name, mutate:, crossover:)
          @alleles ||= []
          @alleles << Allele.new(name, mutate:, crossover:)
        end
      end
    end
  end
end
