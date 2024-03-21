# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Alleles::Option do
  it { is_expected.to have_one(:allele) }
end
