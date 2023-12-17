# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allele do
  it { is_expected.to belong_to(:chromosome) }
end
