# frozen_string_literal: true

T::Genetics::MUTATION_RATE = 0.001

require 'active_record'
require 'rails/railtie'

require 't/genetics/allele'
require 't/genetics/chromosome'
require 't/genetics/version'

include T::Genetics::Chromosome
