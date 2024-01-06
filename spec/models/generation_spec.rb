# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Generation do
  it { is_expected.to belong_to(:chromosome) }
  it { is_expected.to have_many(:organisms) }
end
