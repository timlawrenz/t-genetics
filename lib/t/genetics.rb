# frozen_string_literal: true

require 'active_record'
require 'rails/railtie'

require 't/genetics/allele'
require 't/genetics/chromosome'
require 't/genetics/version'

include T::Genetics::Chromosome
