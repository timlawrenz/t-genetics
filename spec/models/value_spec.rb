# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Value do
  let(:allele) { FactoryBot.create(:allele) }
  let(:organism) { FactoryBot.create(:organism) }
  let(:value) { described_class.create_from(allele, organism:) }

  describe 'mutations' do
    it 'changes the content of data' do
      expect { value.mutate! }.to change(value, :to_s)
    end
  end
end
