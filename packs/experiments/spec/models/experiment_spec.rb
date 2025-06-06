# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Experiment do
  describe 'associations' do
    it { is_expected.to belong_to(:chromosome) }
    it { is_expected.to belong_to(:current_generation).class_name('Generation').with_foreign_key('current_generation_id').optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:chromosome_id) }
    it { is_expected.to validate_presence_of(:external_entity_id) }
    it { is_expected.to validate_presence_of(:external_entity_type) }
    it { is_expected.to validate_presence_of(:status) }
  end
end
