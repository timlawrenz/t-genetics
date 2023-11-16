# frozen_string_literal: true

require 'spec_helper'

RSpec.describe T::Genetics::Allele do
  subject(:allele) { described_class.new(name, mutate: mutation_call, crossover: crossover_class) }

  let(:name) { :number_of_wings }
  let(:mutation_call) { :randomize_number_of_wings }
  let(:crossover_class) { String }

  it 'can be created' do
    expect(allele).to be_a(T::Genetics::Allele)
  end

  describe 'mutation' do
    it 'can mutate' do
      expect(allele).to respond_to(:mutate!)
    end
  end
end
