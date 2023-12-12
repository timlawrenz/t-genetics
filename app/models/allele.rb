class Allele < ApplicationRecord
  belongs_to :chromosome
  delegated_type :inheritable, types: %w[FloatAllele BooleanAllele]
end