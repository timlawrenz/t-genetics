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

    it { is_expected.to validate_presence_of(:feedback_percentage_threshold) }
    it { is_expected.to validate_numericality_of(:feedback_percentage_threshold).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(1.0) }
    it { is_expected.to validate_presence_of(:min_organisms_with_feedback) }
    it { is_expected.to validate_numericality_of(:min_organisms_with_feedback).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:suggestion_count_threshold_multiplier) }
    it { is_expected.to validate_numericality_of(:suggestion_count_threshold_multiplier).is_greater_than_or_equal_to(0.0) }
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

  describe '#ripe_for_evolution?' do
    let(:chromosome) { create(:chromosome_with_alleles) }
    let(:external_entity_object) { create(:chromosome, name: 'External Entity for Ripeness Test') } # Using Chromosome as a dummy
    let(:population_size) { 4 }
    # experiment_config now only for non-auto-evolve specific parts like population_size
    let(:experiment_config) { { 'population_size' => population_size } }
    let!(:experiment) do
      create(:experiment,
             chromosome: chromosome,
             external_entity: external_entity_object,
             configuration: experiment_config,
             feedback_percentage_threshold: 0.75, # Default, but explicit for clarity
             min_organisms_with_feedback: 2,     # Default, but explicit for clarity
             suggestion_count_threshold_multiplier: 3.0) # Default, but explicit for clarity
    end
    let!(:generation) { create(:generation, chromosome: chromosome, iteration: 0) }
    let!(:organisms) { create_list(:organism, population_size, generation: generation) }

    before do
      experiment.update!(current_generation: generation) # Associate generation with experiment
      # Default: experiment is 'pending'. Most tests will need it to be 'running'.
    end

    context 'when experiment is not running' do
      it 'returns false' do
        expect(experiment.ripe_for_evolution?).to be false
      end
    end

    context 'when experiment is running' do
      before { experiment.start! } # Transition to running state

      context 'with no current generation' do
        before { experiment.update!(current_generation: nil) }
        it 'returns false' do
          expect(experiment.ripe_for_evolution?).to be false
        end
      end

      context 'with current generation having no organisms' do
        before { generation.organisms.destroy_all }
        it 'returns false' do
          expect(experiment.ripe_for_evolution?).to be false
        end
      end

      context 'Condition A: Feedback Saturation' do
        before do
          experiment.update!(
            feedback_percentage_threshold: 0.75,
            min_organisms_with_feedback: 3
          )
        end

        it 'returns true when enough organisms have feedback' do
          # 3 out of 4 organisms = 75%, and min_organisms_with_feedback is 3
          organisms.first(3).each do |org|
            create(:performance_log, :with_outcome, experiment: experiment, organism: org, fitness_input_value: 10.0)
          end
          expect(experiment.ripe_for_evolution?).to be true
        end

        it 'returns false if percentage is met but min_organisms_with_feedback is not' do
          experiment.update!(min_organisms_with_feedback: 4)
          organisms.first(3).each do |org| # 75% met, but min_organisms_with_feedback is 4
            create(:performance_log, :with_outcome, experiment: experiment, organism: org, fitness_input_value: 10.0)
          end
          expect(experiment.ripe_for_evolution?).to be false
        end

        it 'returns false if percentage is not met' do
          # 2 out of 4 organisms = 50% (threshold is 75%)
          organisms.first(2).each do |org|
            create(:performance_log, :with_outcome, experiment: experiment, organism: org, fitness_input_value: 10.0)
          end
          expect(experiment.ripe_for_evolution?).to be false
        end

        it 'uses model attribute defaults from factory/migration if not overridden for feedback_percentage_threshold' do
          fresh_experiment = create(:experiment, :running, :with_current_generation,
                                    chromosome: chromosome, external_entity: external_entity_object,
                                    configuration: experiment_config,
                                    min_organisms_with_feedback: 3) # feedback_percentage_threshold uses default 0.75
          # Populate generation for fresh_experiment
          orgs_for_fresh_exp = create_list(:organism, population_size, generation: fresh_experiment.current_generation)

          orgs_for_fresh_exp.first(3).each do |org| # 3 of 4 = 75%
            create(:performance_log, :with_outcome, experiment: fresh_experiment, organism: org, fitness_input_value: 10.0)
          end
          expect(fresh_experiment.ripe_for_evolution?).to be true
        end
      end

      context 'Condition B: Suggestion Volume' do
        before do
          experiment.update!(suggestion_count_threshold_multiplier: 2.0) # pop_size * 2.0 = 4 * 2.0 = 8
        end

        it 'returns true when suggestion volume threshold is met' do
          organisms.cycle.first(8).each_with_index do |org, i| # 8 suggestions
            create(:performance_log, experiment: experiment, organism: org, suggested_at: Time.current - i.minutes)
          end
          expect(experiment.ripe_for_evolution?).to be true
        end

        it 'returns false when suggestion volume threshold is not met' do
          organisms.cycle.first(7).each_with_index do |org, i| # 7 suggestions
            create(:performance_log, experiment: experiment, organism: org, suggested_at: Time.current - i.minutes)
          end
          expect(experiment.ripe_for_evolution?).to be false
        end

        it 'uses model attribute defaults from factory/migration if not overridden for suggestion_count_threshold_multiplier' do
          fresh_experiment = create(:experiment, :running, :with_current_generation,
                                    chromosome: chromosome, external_entity: external_entity_object,
                                    configuration: experiment_config) # suggestion_count_threshold_multiplier uses default 3.0
          # Populate generation for fresh_experiment
          orgs_for_fresh_exp = create_list(:organism, population_size, generation: fresh_experiment.current_generation)

          orgs_for_fresh_exp.cycle.first(12).each_with_index do |org, i| # 4 * 3.0 = 12 suggestions
            create(:performance_log, experiment: fresh_experiment, organism: org, suggested_at: Time.current - i.minutes)
          end
          expect(fresh_experiment.ripe_for_evolution?).to be true
        end

        it 'returns false if suggestion_count_threshold_multiplier is 0' do
          experiment.update!(suggestion_count_threshold_multiplier: 0.0)
          organisms.cycle.first(1).each_with_index do |org, i| # 1 suggestion
            create(:performance_log, experiment: experiment, organism: org, suggested_at: Time.current - i.minutes)
          end
          expect(experiment.ripe_for_evolution?).to be false # Threshold would be 0, but we check for > 0
        end
      end

      context 'when no conditions are met' do
        it 'returns false' do
          # Only 1 organism with feedback (less than 75% and default min 2)
          create(:performance_log, :with_outcome, experiment: experiment, organism: organisms.first, fitness_input_value: 10.0)
          # Only 2 suggestions (less than pop_size * default_multiplier 3 = 12)
          create(:performance_log, experiment: experiment, organism: organisms.second)
          expect(experiment.ripe_for_evolution?).to be false
        end
      end
    end
  end
end
