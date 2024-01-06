# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organism do
  it { is_expected.to belong_to(:generation) }
  it { is_expected.to have_many(:values) }
end
