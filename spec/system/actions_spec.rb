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
          chromosome.alleles << Allele.new_with_float(name: 'hight', minimum: 1, maximum: 10)
        end

        it 'shows the allele in to_s' do
          expect(chromosome.to_s).to include('legs: [minimum: 1, maximum: 50]')
          expect(chromosome.to_s).to include('hight: [minimum: 1.0, maximum: 10.0]')
        end

        context 'when creating a generation' do
          before do
            chromosome.generations.create(iteration: 1)
          end

          it 'attaches the generation to the chromosome' do
            expect(Generation.last.chromosome).to eq(chromosome)
          end

          context 'when creating an organism' do # rubocop:disable RSpec/NestedGroups
            before do
              organism = Organism.create(id: 1, generation: Generation.last)
              puts chromosome.alleles.inspect
              legs = Value.new_from(chromosome.alleles.find_by(name: 'legs'))
              legs.data = 7
              organism.values << legs
              height = Value.new_from(chromosome.alleles.find_by(name: 'height'))
              height.data = 3.5
              organism.values << height
            end

            it 'shows the data' do
              expect(Organism.last.to_s).not_to be_blank
            end
          end
        end
      end
    end
  end
end
