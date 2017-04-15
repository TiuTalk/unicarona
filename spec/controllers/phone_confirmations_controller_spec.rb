require 'rails_helper'

RSpec.describe PhoneConfirmationsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in_as(user) }

  describe 'GET #new' do
    it 'return OK' do
      get :new
      expect(response).to be_ok
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:params) { { user: attributes_for(:user).slice(:phone) } }

      it 'change the user phone and send SMS to confirm it' do
        expect(user).to receive(:confirm_phone!)

        expect { post :create, params: params }.to change { user.reload.phone }.to(params[:user][:phone])

        expect(response).to be_ok
      end
    end

    context 'with invalid params' do
      let(:params) { { user: { phone: '212233445566' } } }

      it 'do not change the user phone' do
        expect(user).to_not receive(:confirm_phone!)

        expect { post :create, params: params }.to_not change { user.reload.phone }

        expect(response).to be_ok
      end
    end
  end

  describe 'POST #confirm' do
    let(:user) { create(:user, phone_confirmation_code: '123456', phone_confirmed: false) }

    context 'with valid params' do
      let(:params) { { user: { phone_confirmation_code: user.phone_confirmation_code } } }

      it 'mark the phone as confirmed and redirect the user' do
        expect { post :confirm, params: params }.to change(user, :phone_confirmed).to(true)

        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid params' do
      let(:params) { { user: { phone_confirmation_code: 'wrong' } } }

      it 'do not confirm the phone' do
        expect { post :confirm, params: params }.to_not change(user, :phone_confirmed).from(false)

        expect(response).to be_ok
      end
    end
  end
end
