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
              organism.set_value(:legs, 7)
              organism.set_value(:height, 3.5)
            end

            it 'shows the data' do
              expect(organism.reload.to_hsh).to eq({ legs: 7, height: 3.5 })
            end

            context 'when setting a fitness' do # rubocop:disable RSpec/NestedGroups
              it 'remembers its fitness' do
                organism.update(fitness: 100)
                expect(organism.fitness).to eq(100)
              end

              it 'changes the fitness of the generation' do
                expect { organism.update(fitness: 100) }
                  .to change(organism.generation, :average_fitness)
              end
            end
          end
        end
      end
    end
  end
end
