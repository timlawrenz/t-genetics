# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'chromosomes/edit' do
  let(:chromosome) do
    Chromosome.create!(
      name: 'MyString'
    )
  end

  before do
    assign(:chromosome, chromosome)
  end

  it 'renders the edit chromosome form' do
    render

    assert_select 'form[action=?][method=?]', chromosome_path(chromosome), 'post' do
      assert_select 'input[name=?]', 'chromosome[name]'
    end
  end
end
