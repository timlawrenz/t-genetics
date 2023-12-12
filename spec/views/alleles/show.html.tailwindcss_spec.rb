require 'rails_helper'

RSpec.describe "alleles/show", type: :view do
  before(:each) do
    assign(:allele, Allele.create!(
      name: "Name",
      chromosome: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
  end
end
