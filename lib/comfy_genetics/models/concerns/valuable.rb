# frozen_string_literal: true

module ComfyGenetics
  module Valuable
    extend ActiveSupport::Concern

    included do
      has_one :value, as: :valuable, touch: true, dependent: :destroy # TODO: ComfyGenetics::Value
      delegate :allele, to: :value # TODO: ComfyGenetics::Allele
      delegate :inheritable, to: :allele # TODO: ComfyGenetics::Inheritable
      delegate :random, to: :inheritable

      def mutate
        Rails.logger.info("mutation! #{value}") # TODO: ComfyGenetics::Value
        self.data = random
      end

      def mutate!
        mutate
        save
      end
    end
  end
end
