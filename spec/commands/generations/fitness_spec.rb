# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Generations::Fitness do
  subject(:call) { described_class.call(generation:) }

  let(:generation) { FactoryBot.create(:generation) }

  context 'without a generation' do
    let(:generation) { nil }

    it { is_expected.to be_failure }
  end

  context 'when there are no organisms' do
    it { is_expected.to be_success }

    it 'returns 0 as total_fitness' do
      expect(call.total_fitness).to eq(0)
    end

    it 'returns nil as average_fitness' do
      expect(call.average_fitness).to be_nil
    end
  end

  context 'when there are no organisms with fitness' do
    before do
      FactoryBot.create(:organism, generation:, fitness: nil)
    end

    it { is_expected.to be_success }

    it 'returns 0 as total_fitness' do
      expect(call.total_fitness).to eq(0)
    end

    it 'returns nil as average_fitness' do
      expect(call.average_fitness).to be_nil
    end
  end

  context 'when all organisms have fitness' do
    before do
      FactoryBot.create(:organism, generation:, fitness: 100)
      FactoryBot.create(:organism, generation:, fitness: 50)
      FactoryBot.create(:organism, generation:, fitness: 30)
    end

    it { is_expected.to be_success }

    it 'considers all organisms and returns 180 as total_fitness' do
      expect(call.total_fitness).to eq(180)
    end

    it 'considers all organisms and returns 60 as average_fitness' do
      expect(call.average_fitness).to eq(60)
    end
  end

  context 'when some organisms have fitness' do
    before do
      FactoryBot.create(:organism, generation:, fitness: 100)
      FactoryBot.create(:organism, generation:, fitness: 50)
      FactoryBot.create(:organism, generation:, fitness: nil)
    end

    it { is_expected.to be_success }

    it 'considers organisms with fitness and returns 150 as total_fitness' do
      expect(call.total_fitness).to eq(150)
    end

    it 'considers organisms with fitness and returns 75 as average_fitness' do
      expect(call.average_fitness).to eq(75)
    end
  end
end
