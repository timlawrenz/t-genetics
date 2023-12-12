require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/alleles", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Allele. As you add validations to Allele, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Allele.create! valid_attributes
      get alleles_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      allele = Allele.create! valid_attributes
      get allele_url(allele)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_allele_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      allele = Allele.create! valid_attributes
      get edit_allele_url(allele)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Allele" do
        expect {
          post alleles_url, params: { allele: valid_attributes }
        }.to change(Allele, :count).by(1)
      end

      it "redirects to the created allele" do
        post alleles_url, params: { allele: valid_attributes }
        expect(response).to redirect_to(allele_url(Allele.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Allele" do
        expect {
          post alleles_url, params: { allele: invalid_attributes }
        }.to change(Allele, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post alleles_url, params: { allele: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested allele" do
        allele = Allele.create! valid_attributes
        patch allele_url(allele), params: { allele: new_attributes }
        allele.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the allele" do
        allele = Allele.create! valid_attributes
        patch allele_url(allele), params: { allele: new_attributes }
        allele.reload
        expect(response).to redirect_to(allele_url(allele))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        allele = Allele.create! valid_attributes
        patch allele_url(allele), params: { allele: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested allele" do
      allele = Allele.create! valid_attributes
      expect {
        delete allele_url(allele)
      }.to change(Allele, :count).by(-1)
    end

    it "redirects to the alleles list" do
      allele = Allele.create! valid_attributes
      delete allele_url(allele)
      expect(response).to redirect_to(alleles_url)
    end
  end
end