# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Alleles::Float do
  it { is_expected.to have_one(:allele) }
end
