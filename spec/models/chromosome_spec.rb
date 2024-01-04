# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Chromosome do
  it { is_expected.to have_many(:alleles) }

  it 'has a to_s method' do
    chromosome = FactoryBot.create(:chromosome)
    expect(chromosome.to_s).to be_a(String)
  end
end
