# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Chromosome do
  it { is_expected.to have_many(:alleles) }
end
