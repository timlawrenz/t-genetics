require 'rails_helper'

RSpec.describe "alleles/edit", type: :view do
  let(:allele) {
    Allele.create!(
      name: "MyString",
      chromosome: nil
    )
  }

  before(:each) do
    assign(:allele, allele)
  end

  it "renders the edit allele form" do
    render

    assert_select "form[action=?][method=?]", allele_path(allele), "post" do

      assert_select "input[name=?]", "allele[name]"

      assert_select "input[name=?]", "allele[chromosome_id]"
    end
  end
end
