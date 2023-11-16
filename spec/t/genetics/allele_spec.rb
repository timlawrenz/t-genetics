# frozen_string_literal: true

require 'spec_helper'

RSpec.describe T::Genetics::Allele do
  subject(:allele) do
    described_class.new(name, mutate: mutation_call,
                              crossover: crossover_class,
                              chromosome: chromosome)
  end

  let(:name) { :number_of_wings }
  let(:mutation_call) { :randomize_number_of_legs }
  let(:chromosome) { BaseChromosome.new }
  let(:crossover_class) { String }

  before do
    base_chromosome = Class.new(Object) do
      require 't/genetics'
      include T::Genetics

      attr_accessor :number_of_wings

      allele :number_of_wings, mutate: :randomize_number_of_legs, crossover: String

      def randomize_number_of_legs
        rand
      end
    end
    stub_const('BaseChromosome', base_chromosome)
  end

  it 'can be created' do
    expect(allele).to be_a(T::Genetics::Allele)
  end

  describe 'mutation' do
    before do
      allow(chromosome).to receive(:randomize_number_of_legs).and_return(6)
      allow(chromosome).to receive(:save)
    end

    it 'can mutate' do
      expect(allele).to respond_to(:mutate!)
    end

    it 'calls the mutation function when it mutates' do
      allele.mutate!(probability: 1)
      expect(chromosome).to have_received(:randomize_number_of_legs)
    end

    it 'sets the attribute to the random value' do
      allele.mutate!(probability: 1)
      expect(chromosome.number_of_wings).to eq(6)
    end

    it 'saves the chromosome' do
      allele.mutate!(probability: 1)
      expect(chromosome).to have_received(:save)
    end
  end
end
