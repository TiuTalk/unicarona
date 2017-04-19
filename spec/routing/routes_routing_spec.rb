require "rails_helper"

RSpec.describe RoutesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/rotas").to route_to("routes#index")
    end

    it "routes to #new" do
      expect(:get => "/rotas/new").to route_to("routes#new")
    end

    it "routes to #show" do
      expect(:get => "/rotas/1").to route_to("routes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/rotas/1/edit").to route_to("routes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/rotas").to route_to("routes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/rotas/1").to route_to("routes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/rotas/1").to route_to("routes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/rotas/1").to route_to("routes#destroy", :id => "1")
    end
  end
end
