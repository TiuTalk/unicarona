require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "POST #set_device_token" do
    let(:token) { SecureRandom.hex(10) }

    context 'with logged in user' do
      let(:user) { create(:user) }
      before { sign_in_as(user) }

      it 'set the device_token on the session & store it on the user' do
        expect do
          post :set_device_token, params: { token: token }
        end.to change { user.reload.device_token }.from(nil).to(token)

        expect(session[:device_token]).to eq(token)
      end
    end

    context 'without logged in user' do
      it 'set the device_token on the session' do
        post :set_device_token, params: { token: token }

        expect(session[:device_token]).to eq(token)
      end
    end
  end
end
