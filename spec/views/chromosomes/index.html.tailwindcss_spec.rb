# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'chromosomes/index' do
  before do
    assign(:chromosomes, [
             Chromosome.create!(
               name: 'Name'
             ),
             Chromosome.create!(
               name: 'Name'
             )
           ])
  end

  it 'renders a list of chromosomes' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Name'.to_s), count: 2
  end
end
