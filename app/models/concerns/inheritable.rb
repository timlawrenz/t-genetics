# frozen_string_literal: true

module Inheritable
  extend ActiveSupport::Concern

  included do
    has_one :allele, as: :inheritable, touch: true, dependent: :destroy
  end
end
