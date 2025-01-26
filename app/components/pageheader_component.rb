# frozen_string_literal: true

class PageheaderComponent < ViewComponent::Base
  def initialize(klass_name:)
    @klass_name = klass_name
  end
end
