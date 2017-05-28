require 'rails_helper'

RSpec.describe RidesController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in_as(user) }

  describe 'GET #index' do
    let!(:rides_taken) { create_list(:ride, 2, passenger: user) }
    let!(:rides_given) { create_list(:ride, 2, driver: user) }

    it 'render the list of rides taken & given' do
      get :index

      expect(assigns(:rides_taken)).to match_array(rides_taken)
      expect(assigns(:rides_given)).to match_array(rides_given)
      expect(response).to be_ok
    end
  end

  describe 'GET #index' do
    context 'with ride taken' do
      let(:ride) { create(:ride, passenger: user) }

      it 'render the ride and respond with OK' do
        get :show,  params: { id: ride.id }

        expect(assigns(:ride)).to eq(ride)
        expect(response).to be_ok
      end
    end

    context 'with ride given' do
      let(:ride) { create(:ride, driver: user) }

      it 'render the ride and respond with OK' do
        get :show,  params: { id: ride.id }

        expect(assigns(:ride)).to eq(ride)
        expect(response).to be_ok
      end
    end

    context 'with invalid ride' do
      let(:ride) { create(:ride) }

      it 'redirect to home' do
        get :show,  params: { id: ride.id }

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do
    let(:route) { create(:route) }
    let(:params) { { ride: { route_id: route.id } } }

    before do
      allow_any_instance_of(User).to receive(:notify)
    end

    it 'create a Ride with correct data' do
      expect do
        post :create, params: params, format: :json
      end.to change { user.rides_taken.count }.by(1)

      ride = Ride.last
      expect(ride.passenger).to eq(user)
      expect(ride.driver).to_not eq(user)
      expect(ride.route).to eq(route)
      expect(ride).to be_pending
    end

    it 'notify the driver' do
      expect_any_instance_of(User).to receive(:notify).with(title: 'Pedido de carona', text: "#{user.first_name} pediu carona para #{route.destination}")

      post :create, params: params, format: :json
    end

    it 'respond with JSON' do
      post :create, params: params, format: :json

      body = JSON.parse(response.body)
      expect(body['id']).to eq(Ride.last.id)
      expect(body['passenger_id']).to eq(user.id)
    end
  end
end
