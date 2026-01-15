require 'rails_helper'

RSpec.describe "Organisms", type: :request do
  describe "GET /chromosomes/:chromosome_id/generations/:generation_id/organisms" do
    let(:chromosome) { FactoryBot.create(:chromosome) }
    let(:generation) { FactoryBot.create(:generation, chromosome: chromosome) }
    let!(:organism) { Organisms::Create.call(generation: generation).organism }

    it "includes the id in the response" do
      get chromosome_generation_organisms_path(chromosome, generation), headers: { 'ACCEPT' => 'application/json' }
      
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.first).to have_key("id")
      expect(json_response.first["id"]).to eq(organism.id)
    end
  end
end
