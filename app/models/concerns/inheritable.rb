module Inheritable
  extend ActiveSupport::Concern

  included do
    has_one :allele, as: :allelable, touch: true, dependent: :detroy
  end
end
