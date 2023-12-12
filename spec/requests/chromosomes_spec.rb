# frozen_string_literal: true

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

RSpec.describe '/chromosomes' do
  # This should return the minimal set of attributes required to create a valid
  # Chromosome. As you add validations to Chromosome, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    skip('Add a hash of attributes valid for your model')
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Chromosome.create! valid_attributes
      get chromosomes_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      chromosome = Chromosome.create! valid_attributes
      get chromosome_url(chromosome)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_chromosome_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      chromosome = Chromosome.create! valid_attributes
      get edit_chromosome_url(chromosome)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Chromosome' do
        expect do
          post chromosomes_url, params: { chromosome: valid_attributes }
        end.to change(Chromosome, :count).by(1)
      end

      it 'redirects to the created chromosome' do
        post chromosomes_url, params: { chromosome: valid_attributes }
        expect(response).to redirect_to(chromosome_url(Chromosome.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Chromosome' do
        expect do
          post chromosomes_url, params: { chromosome: invalid_attributes }
        end.not_to change(Chromosome, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post chromosomes_url, params: { chromosome: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested chromosome' do
        chromosome = Chromosome.create! valid_attributes
        patch chromosome_url(chromosome), params: { chromosome: new_attributes }
        chromosome.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the chromosome' do
        chromosome = Chromosome.create! valid_attributes
        patch chromosome_url(chromosome), params: { chromosome: new_attributes }
        chromosome.reload
        expect(response).to redirect_to(chromosome_url(chromosome))
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        chromosome = Chromosome.create! valid_attributes
        patch chromosome_url(chromosome), params: { chromosome: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested chromosome' do
      chromosome = Chromosome.create! valid_attributes
      expect do
        delete chromosome_url(chromosome)
      end.to change(Chromosome, :count).by(-1)
    end

    it 'redirects to the chromosomes list' do
      chromosome = Chromosome.create! valid_attributes
      delete chromosome_url(chromosome)
      expect(response).to redirect_to(chromosomes_url)
    end
  end
end
