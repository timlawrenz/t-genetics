# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organisms::Clone do
  describe '.call' do
    let!(:chromosome) { FactoryBot.create(:chromosome) }
    let!(:generation) { FactoryBot.create(:generation, chromosome:) }
    let!(:original_organism) { FactoryBot.create(:organism, generation:) }

    # Setup alleles for the chromosome
    let!(:allele_integer) { Allele.create!(chromosome:, name: 'legs', inheritable: Alleles::Integer.create!(minimum: 1, maximum: 8)) }
    let!(:allele_boolean) { Allele.create!(chromosome:, name: 'flies', inheritable: Alleles::Boolean.create!) }

    # Setup values for the original organism only if alleles are present
    before do
      # Ensure original_organism starts with no values unless explicitly added
      original_organism.values.destroy_all

      # Add values if alleles are defined for this context
      if defined?(allele_integer) && allele_integer.persisted?
        val_int = Value.new_from(allele_integer, organism: original_organism)
        val_int.data = 4
        val_int.save!
      end

      if defined?(allele_boolean) && allele_boolean.persisted?
        val_bool = Value.new_from(allele_boolean, organism: original_organism)
        val_bool.data = true
        val_bool.save!
      end
      original_organism.reload
    end

    subject(:command_call) { described_class.call(organism: original_organism, target_generation: original_organism.generation) }

    context 'when the original organism has values' do
      it 'succeeds' do
        expect(command_call).to be_success
      end

      it 'returns the cloned organism in the context' do
        expect(command_call.dolly_clone).to be_an(Organism)
      end

      it 'creates a new organism record' do
        expect { command_call }.to change(Organism, :count).by(1)
      end

      it 'ensures the cloned organism is a different instance' do
        expect(command_call.dolly_clone).not_to eq original_organism
      end

      it 'assigns the cloned organism to the same generation' do
        expect(command_call.dolly_clone.generation).to eq original_organism.generation
      end

      it 'copies the values from the original organism' do
        cloned_organism = command_call.dolly_clone

        expect(cloned_organism.values.count).to eq original_organism.values.count
        expect(cloned_organism.to_hsh).to eq original_organism.to_hsh
      end

      it 'creates new value records for the clone, not re-using old ones' do
        original_value_ids = original_organism.values.pluck(:id).sort
        cloned_organism = command_call.dolly_clone
        cloned_value_ids = cloned_organism.values.pluck(:id).sort

        expect(cloned_value_ids).not_to be_empty
        expect(cloned_value_ids).not_to eq original_value_ids
        expect(cloned_value_ids.size).to eq original_value_ids.size

        # Detailed check for one value
        original_int_value = original_organism.values.find { |v| v.allele == allele_integer }
        cloned_int_value = cloned_organism.values.find { |v| v.allele == allele_integer }

        expect(cloned_int_value).not_to be_nil
        expect(cloned_int_value.id).not_to eq original_int_value.id
        expect(cloned_int_value.data).to eq original_int_value.data
        expect(cloned_int_value.allele).to eq original_int_value.allele # Same allele
        expect(cloned_int_value.organism).to eq cloned_organism # Belongs to clone
      end
    end

    context 'when original organism has a specific fitness' do
      before do
        original_organism.update!(fitness: 0.75)
      end

      it 'copies the fitness to the cloned organism' do
        # This assumes the Clone command is responsible for copying fitness.
        # If fitness should be reset or calculated anew, this test would need adjustment.
        expect(command_call.dolly_clone.fitness).to eq 0.75
      end
    end

    context 'when original organism has no values' do
      let!(:organism_no_values) { FactoryBot.create(:organism, generation:) }

      subject(:command_call_no_values) { described_class.call(organism: organism_no_values, target_generation: organism_no_values.generation) }

      before do
        # Ensure this organism truly has no values
        organism_no_values.values.destroy_all
      end

      it 'succeeds' do
        expect(command_call_no_values).to be_success
      end

      it 'creates a clone with no values' do
        cloned_organism = command_call_no_values.dolly_clone
        expect(cloned_organism).to be_an(Organism)
        expect(cloned_organism.id).not_to eq organism_no_values.id
        expect(cloned_organism.values).to be_empty
      end
    end

    context 'when the command fails (e.g., organism is nil or invalid)' do
      it 'is not successful if organism is nil' do
        result = described_class.call(organism: nil, target_generation: generation)
        expect(result).not_to be_success
        # Depending on GLCommand setup, check for errors
        # expect(result.errors).not_to be_empty
      end

      # Add more failure cases if applicable, e.g., if organism is not persisted.
    end
  end
end
