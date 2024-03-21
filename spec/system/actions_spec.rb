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
          chromosome.alleles << Allele.new_with_boolean(name: 'flies')
          chromosome.alleles << Allele.new_with_option(name: 'color', choices: %i[green blue])
        end

        it 'shows the allele in to_s' do
          expect(chromosome.to_s).to include('legs: [minimum: 1, maximum: 50]')
          expect(chromosome.to_s).to include('height: [minimum: 1.0, maximum: 10.0]')
          expect(chromosome.to_s).to include('flies: [boolean]')
          expect(chromosome.to_s).to include('color: [choices: ["green", "blue"]]')
        end

        context 'when creating a generation' do
          let(:generation) { chromosome.generations.create(iteration: 1) }

          it 'attaches the generation to the chromosome' do
            expect(generation.chromosome).to eq(chromosome)
          end

          context 'when creating an organism' do # rubocop:disable RSpec/NestedGroups
            let(:organism) { Organisms::Create.call(generation:).organism }

            before do
              organism.set_value(:legs, 7)
              organism.set_value(:height, 3.5)
              organism.set_value(:flies, true)
              organism.set_value(:color, :blue)
            end

            it 'shows the data' do
              expect(organism.reload.to_hsh)
                .to eq({ color: 'blue', legs: 7, height: 3.5, flies: true })
            end

            context 'when setting a fitness' do # rubocop:disable RSpec/NestedGroups
              it 'remembers its fitness' do
                organism.update(fitness: 100)
                expect(organism.fitness).to eq(100)
              end

              it 'changes the fitness of the generation' do
                expect { organism.update(fitness: 100) }
                  .to change { Generations::Fitness.call(generation:).average_fitness }
                  .from(nil)
                  .to(100)
              end

              context 'when adding a second organism' do # rubocop:disable RSpec/NestedGroups
                let(:organism2) { Organisms::Create.call(generation:).organism }

                before do
                  organism.update(fitness: 100)
                  organism2.mutate!(probability: 1)
                end

                it 'has values for all alleles' do
                  expect(organism2.values.by_name(:legs).first.data).not_to be_nil
                  expect(organism2.values.by_name(:height).first.data).not_to be_nil
                  expect(organism2.values.by_name(:flies).first.data).not_to be_nil
                  expect(organism2.values.by_name(:color).first.data).not_to be_nil
                end

                context 'when setting a fitness' do # rubocop:disable RSpec/NestedGroups
                  it 'changes the fitness of the generation' do
                    expect { organism2.update(fitness: 10) }
                      .to change { Generations::Fitness.call(generation:).average_fitness }
                      .from(100)
                      .to(55)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
