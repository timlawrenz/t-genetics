# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Values::Integer do
  it { is_expected.to have_one(:value) }
end
