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
    # it { is_expected.to validate_presence_of(:status) } # AASM handles status presence and inclusion in states
  end

  describe 'AASM states' do
    subject(:experiment) { create(:experiment) } # Assuming a factory :experiment exists

    it 'starts in pending state' do
      expect(experiment).to be_pending
    end

    it 'transitions from pending to running on start event' do
      experiment.start!
      expect(experiment).to be_running
    end

    it 'transitions from running to completed on complete event' do
      experiment.status = :running # or experiment.start!
      experiment.complete!
      expect(experiment).to be_completed
    end

    it 'transitions from running to failed on fail event' do
      experiment.status = :running # or experiment.start!
      experiment.fail!
      expect(experiment).to be_failed
    end

    it 'does not transition from pending to completed directly' do
      expect { experiment.complete! }.to raise_error(AASM::InvalidTransition)
    end

    it 'does not transition from pending to failed directly' do
      expect { experiment.fail! }.to raise_error(AASM::InvalidTransition)
    end
  end
end
