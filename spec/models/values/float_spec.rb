# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Values::Float do
  it { is_expected.to have_one(:value) }

  describe 'default values' do
    let(:chromosome) { FactoryBot.create(:chromosome) }
    let(:generation) { FactoryBot.create(:generation, chromosome:) }
    let(:organism) { Organisms::Create.call(generation:).organism }

    before do
      chromosome.alleles << Allele.new_with_float(name: 'bgm', minimum: 0, maximum: 1)
    end

    it 'does not return nil for data' do
      expect(organism.to_hsh[:bgm]).to eq(0)
    end
  end
end
