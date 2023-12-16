# frozen_string_literal: true

module Inheritable
  extend ActiveSupport::Concern

  included do
    has_one :allele, as: :allelable, touch: true, dependent: :destroy
  end
end
