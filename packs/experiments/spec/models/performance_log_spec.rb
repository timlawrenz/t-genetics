# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PerformanceLog do
  describe 'associations' do
    it { is_expected.to belong_to(:experiment) }
    it { is_expected.to belong_to(:organism) }
  end

  describe 'validations' do
    subject { create(:performance_log) } # Assuming you'll create a factory

    it { is_expected.to validate_presence_of(:experiment) }
    it { is_expected.to validate_presence_of(:organism) }
    it { is_expected.to validate_presence_of(:suggested_at) }
  end
end
