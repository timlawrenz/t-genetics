require "rails_helper"

RSpec.describe AllelesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/alleles").to route_to("alleles#index")
    end

    it "routes to #new" do
      expect(get: "/alleles/new").to route_to("alleles#new")
    end

    it "routes to #show" do
      expect(get: "/alleles/1").to route_to("alleles#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/alleles/1/edit").to route_to("alleles#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/alleles").to route_to("alleles#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/alleles/1").to route_to("alleles#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/alleles/1").to route_to("alleles#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/alleles/1").to route_to("alleles#destroy", id: "1")
    end
  end
end
