# frozen_string_literal: true

module Valuable
  extend ActiveSupport::Concern

  included do
    has_one :value, as: :valuable, touch: true, dependent: :destroy
    delegate :allele, to: :value

    def to_s
      data
    end

    def random
      inheritable = allele.inheritable
      rand(inheritable.minimum..inheritable.maximum)
    end

    def mutate!
      self.data = random
    end
  end
end
