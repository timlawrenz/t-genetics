# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'alleles/index' do
  before do
    assign(:alleles, FactoryBot.create_list(:allele, 2))
  end

  it 'renders a list of alleles' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Name'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 4
  end
end
