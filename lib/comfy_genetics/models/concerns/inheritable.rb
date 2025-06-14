# frozen_string_literal: true

module ComfyGenetics
  module Inheritable
    extend ActiveSupport::Concern

    included do
      has_one :allele, as: :inheritable, touch: true, dependent: :destroy # TODO: ComfyGenetics::Allele
    end
  end
end
