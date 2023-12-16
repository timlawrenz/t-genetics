# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'alleles/edit' do
  let(:allele) do
    FactoryBot.create(:allele, inheritable: FactoryBot.create(:float_allele))
  end

  before do
    assign(:allele, allele)
  end

  it 'renders the edit allele form' do
    render

    assert_select 'form[action=?][method=?]', allele_path(allele), 'post' do
      assert_select 'input[name=?]', 'allele[name]'

      assert_select 'input[name=?]', 'allele[chromosome_id]'
    end
  end
end
