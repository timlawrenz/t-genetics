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
        ##
        # Defines a mutatable, inheritable characteristic of the Chromosome
        #
        def allele(name, mutate:, crossover:)
          @alleles ||= []
          @alleles << name
        end
      end
    end
  end
end
