require 'rails_helper'

RSpec.describe RidesController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in_as(user) }

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
      expect_any_instance_of(User).to receive(:notify).with(title: 'Pedido de carona', text: "#{user.first_name} quer uma carona para #{route.destination}")

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
