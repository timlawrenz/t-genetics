# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organisms::Crossover do
  context 'without organisms' do
    subject(:call) { described_class.call() }

    it { is_expected.to be_failure }
  end

  context 'with organisms' do
    before do
      stub_const 'CROSS_OVER_RATE', 100
    end

    subject(:call) { described_class.call(organisms:) }
    let(:parameters) { { organisms: } }
    let(:chromosome) { FactoryBot.create(:chromosome) }
    let(:alleles) { FactoryBot.create(:allele, chromosome:) }
    let(:generation) { FactoryBot.create(:generation, chromosome:) }
    let(:organisms) do
      alleles
      generation.reload

      [Organisms::Create.call(generation:).organism,
       Organisms::Create.call(generation:).organism]
    end

    it { is_expected.to be_success }

    it 'comes with organisms that have values' do
      organisms.each do |organism|
        expect(organism.reload.values).not_to be_blank
      end
    end

    it 'calls the crossover algorithm' do
      expect { call }.to(change { organisms.map(&:reload).map(&:values) })
    end
  end
end
