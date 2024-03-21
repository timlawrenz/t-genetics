# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organism do
  it { is_expected.to belong_to(:generation) }
  it { is_expected.to have_many(:values) }

  describe 'mutate!' do
    let(:generation) { FactoryBot.create(:generation) }
    let(:chromosome) { FactoryBot.create(:chromosome) }
    let(:organism) { Organisms::Create.call(generation:).organism }

    before do
      chromosome.generations << generation
      chromosome.alleles << Allele.new_with_integer(name: 'legs', minimum: 1, maximum: 50)
      chromosome.alleles << Allele.new_with_float(name: 'height', minimum: 1, maximum: 10)
      chromosome.alleles << Allele.new_with_boolean(name: 'flies')
      chromosome.alleles << Allele.new_with_option(name: 'color', choices: %w[green blue])
    end

    it 'sets all values' do
      # rubocop:disable Style/HashEachMethods
      organism.mutate!(probability: 1)

      organism.values.each do |value|
        expect(value.data).not_to be_nil
      end
      # rubocop:enable Style/HashEachMethods
    end
  end
end
