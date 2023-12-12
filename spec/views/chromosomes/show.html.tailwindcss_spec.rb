# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'chromosomes/show' do
  before do
    assign(:chromosome, Chromosome.create!(
                          name: 'Name'
                        ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
  end
end
