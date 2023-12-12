require 'rails_helper'

RSpec.describe "alleles/new", type: :view do
  before(:each) do
    assign(:allele, Allele.new(
      name: "MyString",
      chromosome: nil
    ))
  end

  it "renders new allele form" do
    render

    assert_select "form[action=?][method=?]", alleles_path, "post" do

      assert_select "input[name=?]", "allele[name]"

      assert_select "input[name=?]", "allele[chromosome_id]"
    end
  end
end
