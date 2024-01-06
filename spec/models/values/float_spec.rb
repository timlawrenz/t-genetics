# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Values::Float do
  it { is_expected.to have_one(:value) }
end
