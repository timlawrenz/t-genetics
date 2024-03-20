# frozen_string_literal: true

module Valuable
  extend ActiveSupport::Concern

  included do
    has_one :value, as: :valuable, touch: true, dependent: :destroy
    delegate :allele, to: :value

    def random
      inheritable = allele.inheritable
      rand(inheritable.minimum..inheritable.maximum)
    end

    def mutate
      Rails.logger.info("mutation! #{to_s}")
      self.data = random
    end

    def mutate!
      mutate
      save
    end
  end
end
