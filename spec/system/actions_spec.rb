# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Basic Actions' do # rubocop:disable RSpec/DescribeClass
  context 'when setting up an experiment' do
    context 'when defining a chromosome' do
      let(:chromosome) { Chromosome.create(name: 'experiment 1') }

      it 'shows its content in to_s' do
        expect(chromosome.to_s).to include('experiment 1')
        expect(chromosome.to_s).to include(chromosome.id.to_s)
      end

      context 'when defining allele' do
        let(:name) { 'numberOfLegs' }

        before do
          chromosome.alleles << Allele.new_with_integer(name: 'legs', minimum: 1, maximum: 50)
          chromosome.alleles << Allele.new_with_float(name: 'height', minimum: 1, maximum: 10)
        end

        it 'shows the allele in to_s' do
          expect(chromosome.to_s).to include('legs: [minimum: 1, maximum: 50]')
          expect(chromosome.to_s).to include('height: [minimum: 1.0, maximum: 10.0]')
        end

        context 'when creating a generation' do
          before do
            chromosome.generations.create(iteration: 1)
          end

          it 'attaches the generation to the chromosome' do
            expect(Generation.last.chromosome).to eq(chromosome)
          end

          context 'when creating an organism' do # rubocop:disable RSpec/NestedGroups
            let(:organism) { Organism.factory(generation: Generation.last) }

            before do
              organism.values.by_name(:legs).first.valuable.update(data: 7)
              organism.values.by_name(:height).first.valuable.update(data: 3.5)
            end

            it 'shows the data' do
              expect(organism.reload.to_hsh).to eq({ legs: 7, height: 3.5 })
            end
          end
        end
      end
    end
  end
end
