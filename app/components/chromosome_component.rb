# frozen_string_literal: true

class ChromosomeComponent < ViewComponent::Base
  def initialize(chromosome:)
    @chromosome = chromosome
  end
end
