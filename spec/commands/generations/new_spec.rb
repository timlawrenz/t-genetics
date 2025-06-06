# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Generations::New do
  describe '.call' do
    let(:parent_generation_double) { instance_double(Generation, id: 1) }
    let(:offspring_generation_double) { instance_double(Generation, id: 2) }
    let(:organisms_association_proxy_double) { double('ActiveRecord::Associations::CollectionProxy') } # rubocop:disable RSpec/VerifiedDoubles

    let(:parent1_double) { instance_double(Organism, id: 101) }
    let(:parent2_double) { instance_double(Organism, id: 102) }

    let(:child1_double) { instance_double(Organism, id: 201) }
    let(:child2_double) { instance_double(Organism, id: 202) }

    let(:pick_parent1_success_context) do
      # Using plain double as GLCommand::Context uses method_missing for dynamic attributes
      context_double = double('GLCommand::Context (Pick Success)', success?: true, failure?: false)
      allow(context_double).to receive(:errors).and_return(ActiveModel::Errors.new(nil))
      allow(context_double).to receive(:organism).and_return(parent1_double)
      context_double
    end
    let(:pick_parent2_success_context) do
      context_double = double('GLCommand::Context (Pick Success)', success?: true, failure?: false)
      allow(context_double).to receive(:errors).and_return(ActiveModel::Errors.new(nil))
      allow(context_double).to receive(:organism).and_return(parent2_double)
      context_double
    end
    let(:pick_failure_context) do
      errors = ActiveModel::Errors.new(nil)
      errors.add(:base, 'Pick failed')
      context_double = double('GLCommand::Context (Pick Failure)', success?: false, failure?: true)
      allow(context_double).to receive(:errors).and_return(errors)
      allow(context_double).to receive(:organism).and_return(nil)
      context_double
    end

    let(:procreate_success_context) do
      context_double = double('GLCommand::Context (Procreate Success)', success?: true, failure?: false)
      allow(context_double).to receive(:errors).and_return(ActiveModel::Errors.new(nil))
      allow(context_double).to receive(:children).and_return([child1_double, child2_double])
      context_double
    end
    let(:procreate_failure_context) do
      errors = ActiveModel::Errors.new(nil)
      errors.add(:base, 'Procreate failed')
      context_double = double('GLCommand::Context (Procreate Failure)', success?: false, failure?: true)
      allow(context_double).to receive(:errors).and_return(errors)
      allow(context_double).to receive(:children).and_return([])
      context_double
    end

    # Default organism_count for most tests
    let(:organism_count) { 2 }

    subject(:command_call) do
      described_class.call(
        parent_generation: parent_generation_double,
        offspring_generation: offspring_generation_double,
        organism_count:
      )
    end

    before do
      # GLCommand type checks
      allow(parent_generation_double).to receive(:is_a?).with(Generation).and_return(true)
      allow(parent_generation_double).to receive(:kind_of?).with(Generation).and_return(true)
      allow(offspring_generation_double).to receive(:is_a?).with(Generation).and_return(true)
      allow(offspring_generation_double).to receive(:kind_of?).with(Generation).and_return(true)

      # Mock offspring_generation.organisms association
      allow(offspring_generation_double).to receive(:organisms).and_return(organisms_association_proxy_double)

      # Mock Generations::Pick.call
      # This will be called twice per loop iteration in the `parents` method
      allow(Generations::Pick).to receive(:call)
        .with(generation: parent_generation_double)
        .and_return(pick_parent1_success_context, pick_parent2_success_context) # Default to success for both picks

      # Mock Organisms::Procreate.call
      allow(Organisms::Procreate).to receive(:call)
        .with(parents: [parent1_double, parent2_double], target_generation: offspring_generation_double)
        .and_return(procreate_success_context) # Default to success

      # Mock child.update
      allow(child1_double).to receive(:update).with(generation: offspring_generation_double).and_return(true)
      allow(child2_double).to receive(:update).with(generation: offspring_generation_double).and_return(true)

      # Control loop: offspring_generation.organisms.count
      # Start with 0, then enough to satisfy organism_count after first Procreate call (assuming Procreate returns 2 children)
      allow(organisms_association_proxy_double).to receive(:count).and_return(0, organism_count)
    end

    context 'when successful' do
      it 'succeeds' do
        expect(command_call).to be_success
      end

      it 'calls Generations::Pick twice for parents' do
        command_call
        expect(Generations::Pick).to have_received(:call).with(generation: parent_generation_double).twice
      end

      it 'calls Organisms::Procreate with the picked parents and target_generation' do
        command_call
        expect(Organisms::Procreate).to have_received(:call).with(parents: [parent1_double, parent2_double], target_generation: offspring_generation_double).once
      end

      it 'updates each child with the offspring_generation' do
        command_call
        expect(child1_double).to have_received(:update).with(generation: offspring_generation_double)
        expect(child2_double).to have_received(:update).with(generation: offspring_generation_double)
      end

      it 'continues until organism_count is met' do
        # This test relies on the before block's count mock being called correctly.
        # For organism_count = 2, and Procreate returning 2 children, it should loop once.
        command_call
        expect(organisms_association_proxy_double).to have_received(:count).twice # Initial check (0), check after update (2)
        expect(Organisms::Procreate).to have_received(:call).once
      end
    end

    context 'when organism_count is not provided' do
      let(:organism_count) { nil } # Simulate not providing the param
      let(:default_organism_count) { 20 }

      before do
        # Adjust loop control for default_organism_count
        # Simulate multiple iterations if Procreate returns 2 children at a time
        call_counts = [0]
        current_total = 0
        while current_total < default_organism_count
          current_total += 2 # Assuming Procreate makes 2 children
          call_counts << [current_total, default_organism_count].min # Don't overshoot if count is odd
        end
        allow(organisms_association_proxy_double).to receive(:count).and_return(*call_counts)

        # Ensure Procreate is stubbed to be callable multiple times if needed
        allow(Organisms::Procreate).to receive(:call)
          .with(parents: [parent1_double, parent2_double], target_generation: offspring_generation_double)
          .and_return(procreate_success_context)
      end

      it 'defaults to creating 20 organisms' do
        command_call # Call with organism_count: nil
        # Verify Procreate was called enough times to make 20 organisms (10 times if 2 children per call)
        expect(Organisms::Procreate).to have_received(:call)
          .with(parents: [parent1_double, parent2_double], target_generation: offspring_generation_double)
          .exactly(default_organism_count / 2).times # Assuming Procreate always returns 2 children
      end
    end

    context 'when Generations::Pick fails for the first parent' do
      before do
        allow(Generations::Pick).to receive(:call)
          .with(generation: parent_generation_double)
          .and_return(pick_failure_context, pick_parent1_success_context) # First pick fails
      end

      it 'calls Organisms::Procreate with only one parent (or handles as Procreate expects)' do
        # The `parents` method in Generations::New collects successful picks.
        # Organisms::Procreate is expected to handle cases with not enough parents.
        # Here, Procreate will be called with `parents: [parent1_double]`
        allow(Organisms::Procreate).to receive(:call)
          .with(parents: [parent1_double], target_generation: offspring_generation_double) # Only one parent picked
          .and_return(procreate_failure_context) # Procreate should fail or handle this
        command_call
        expect(Organisms::Procreate).to have_received(:call).with(parents: [parent1_double], target_generation: offspring_generation_double)
      end

      it 'fails (because Procreate will fail with one parent)' do
        procreate_errors = ActiveModel::Errors.new(nil)
        procreate_errors.add(:parents, 'must be an array of two parents')
        procreate_one_parent_failure_context = double('GLCommand::Context (Procreate One Parent Failure)', success?: false, failure?: true)
        allow(procreate_one_parent_failure_context).to receive(:errors).and_return(procreate_errors)
        allow(procreate_one_parent_failure_context).to receive(:children).and_return([])
        allow(Organisms::Procreate).to receive(:call)
          .with(parents: [parent1_double], target_generation: offspring_generation_double)
          .and_return(procreate_one_parent_failure_context)
        expect(command_call).to be_failure
        expect(command_call.errors[:parents]).to include('must be an array of two parents')
      end
    end

    context 'when Organisms::Procreate fails' do
      before do
        allow(Organisms::Procreate).to receive(:call)
          .with(parents: [parent1_double, parent2_double], target_generation: offspring_generation_double)
          .and_return(procreate_failure_context)
      end

      it 'fails' do
        expect(command_call).to be_failure
      end

      it 'propagates errors from Organisms::Procreate' do
        expect(command_call.errors[:base]).to include('Procreate failed')
      end

      it 'does not attempt to update children' do
        command_call
        expect(child1_double).not_to have_received(:update)
        expect(child2_double).not_to have_received(:update)
      end
    end

    context 'when child.update fails by returning false (but does not raise error)' do
      let(:organism_count) { 2 } # Ensure loop runs once
      before do
        allow(child1_double).to receive(:update).with(generation: offspring_generation_double).and_return(false)
        # child2_double update is still true
      end

      # The current Generations::New command does not check the return value of `child.update`.
      # Therefore, even if update returns false, the command will proceed and be successful
      # unless an exception is raised.
      it 'succeeds (as per current command implementation)' do
        expect(command_call).to be_success
      end

      it 'still attempts to update all children from that Procreate batch' do
        command_call
        expect(child1_double).to have_received(:update).with(generation: offspring_generation_double)
        expect(child2_double).to have_received(:update).with(generation: offspring_generation_double) # This one is still called
      end
    end

    context 'when child.update raises an exception' do
      let(:organism_count) { 2 } # Ensure loop runs once
      let(:update_error_message) { 'Update failed!' }
      before do
        allow(child1_double).to receive(:update).with(generation: offspring_generation_double).and_raise(StandardError.new(update_error_message))
      end

      it 'fails' do
        expect(command_call).to be_failure
      end

      it 'propagates the exception message' do
        expect(command_call.errors.full_messages.join).to include(update_error_message)
      end

      it 'does not attempt to update subsequent children from that Procreate batch' do
        command_call
        expect(child1_double).to have_received(:update).with(generation: offspring_generation_double)
        expect(child2_double).not_to have_received(:update)
      end
    end
  end
end
