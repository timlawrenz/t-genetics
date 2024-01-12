# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Generations::Fitness do
  subject(:call) { described_class.call(parameters) }


  context 'without a generation' do
    let(:parameters) { {} }

    it { is_expected.to be_failure }
  end

  context 'when there are no organisms' do
    let(:generation) { FactoryBot.create(:generation) }
    let(:parameters) { { generation: } }

    it { is_expected.to be_success }

    it 'returns 0 as total_fitness' do
      expect(call.total_fitness).to eq(0)
    end

    it 'returns nil as average_fitness' do
      expect(call.average_fitness).to be_nil
    end
  end

  context 'when there are no organisms with fitness' do
    let(:generation) { FactoryBot.create(:generation) }
    let(:parameters) { { generation: } }

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
end
