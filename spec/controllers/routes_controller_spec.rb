require 'rails_helper'

RSpec.describe RoutesController, type: :controller do
  let(:user) { create(:user) }
  let!(:route) { create(:route, user: user) }

  let(:valid_attributes) { attributes_for(:route).slice(:origin, :destination, :weekdays, :hour) }
  let(:invalid_attributes) { valid_attributes.merge(destination: '') }

  before { sign_in_as(user) }

  before do
    coordinates = [FFaker::Geolocation.lat, FFaker::Geolocation.lng]
    allow(Geocoder).to receive(:coordinates).and_return(coordinates)
  end

  describe "GET #search" do
    it 'respond with OK' do
      get :search
      expect(response).to be_ok
    end
  end

  describe "POST #search" do
    let!(:route_a) { create(:route) }
    let!(:route_b) { create(:route) }

    let(:origin) { route_a.reload.send(:origin_coordinates).join(',') }
    let(:destination) { route_a.reload.send(:destination_coordinates).join(',') }

    it 'respond with OK & results' do
      post :search, params: { route: { origin: origin, destination: destination } }

      expect(assigns(:routes)).to match_array([route_a])
      expect(response).to be_ok
    end
  end

  describe "GET #index" do
    it "assigns all routes as @routes" do
      get :index, params: {}
      expect(assigns(:routes)).to eq([route])
    end
  end

  describe "GET #show" do
    it "assigns the requested route as @route" do
      get :show, params: {id: route.to_param}
      expect(assigns(:route)).to eq(route)
    end

    it 'redirect to home with invalid route' do
      get :show, params: { id: 0 }
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET #new" do
    it "assigns a new route as @route" do
      get :new, params: {}
      expect(assigns(:route)).to be_a_new(Route)
    end
  end

  describe "GET #edit" do
    it "assigns the requested route as @route" do
      get :edit, params: {id: route.to_param}
      expect(assigns(:route)).to eq(route)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Route" do
        expect {
          post :create, params: {route: valid_attributes}
        }.to change(Route, :count).by(1)
      end

      it "assigns a newly created route as @route" do
        post :create, params: {route: valid_attributes}
        expect(assigns(:route)).to be_a(Route)
        expect(assigns(:route)).to be_persisted
      end

      it "redirects to the created route" do
        post :create, params: {route: valid_attributes}
        expect(response).to redirect_to(routes_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved route as @route" do
        post :create, params: {route: invalid_attributes}
        expect(assigns(:route)).to be_a_new(Route)
      end

      it "re-renders the 'new' template" do
        post :create, params: {route: invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { origin: 'Endereço' } }

      it "updates the requested route" do
        put :update, params: {id: route.to_param, route: new_attributes}
        route.reload
        expect(route.origin).to eq('Endereço')
      end

      it "assigns the requested route as @route" do
        put :update, params: {id: route.to_param, route: valid_attributes}
        expect(assigns(:route)).to eq(route)
      end

      it "redirects to the route" do
        put :update, params: {id: route.to_param, route: valid_attributes}
        expect(response).to redirect_to(routes_path)
      end
    end

    context "with invalid params" do
      it "assigns the route as @route" do
        put :update, params: {id: route.to_param, route: invalid_attributes}
        expect(assigns(:route)).to eq(route)
      end

      it "re-renders the 'edit' template" do
        put :update, params: {id: route.to_param, route: invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested route" do
      expect {
        delete :destroy, params: {id: route.to_param}
      }.to change(Route, :count).by(-1)
    end

    it "redirects to the routes list" do
      delete :destroy, params: {id: route.to_param}
      expect(response).to redirect_to(routes_url)
    end
  end
end
