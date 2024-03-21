# frozen_string_literal: true

module Valuable
  extend ActiveSupport::Concern

  included do
    has_one :value, as: :valuable, touch: true, dependent: :destroy
    delegate :allele, to: :value
    delegate :inheritable, to: :allele
    delegate :random, to: :inheritable

    def mutate
      Rails.logger.info("mutation! #{value}")
      self.data = random
    end

    def mutate!
      mutate
      save
    end
  end
end
