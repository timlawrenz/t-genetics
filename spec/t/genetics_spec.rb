# frozen_string_literal: true

require 'spec_helper'

RSpec.describe T::Genetics do
  it 'has a version number' do
    expect(T::Genetics::VERSION).to be_a(String)
  end

  describe 'base behavior' do
    before do
      base_chromosome = Class.new(Object) do
        require 't/genetics'
        include T::Genetics

        allele :number_of_legs, mutate: :randomize_number_of_legs, crossover: :random
      end
      stub_const('BaseChromosome', base_chromosome)
    end

    it 'can define allele' do
      expect(BaseChromosome.instance_variables).to include(:@alleles)
    end

    it 'can remember allele' do
      expect(BaseChromosome.instance_variable_get(:@alleles).first).to be_a(T::Genetics::Allele)
    end
  end
end
