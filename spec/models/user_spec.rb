require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:routes).inverse_of(:user) }
    it { is_expected.to have_many(:rides_given).class_name(Ride).with_foreign_key(:driver_id).inverse_of(:driver) }
    it { is_expected.to have_many(:rides_taken).class_name(Ride).with_foreign_key(:passenger_id).inverse_of(:passenger) }
  end

  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_length_of(:password).is_at_least(8).on(:create) }

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to allow_value('user@example.com', 'user@example.com.br').for(:email) }
    it { is_expected.to_not allow_value('user@', 'user@@example.com', 'hello').for(:email) }

    it { is_expected.to allow_value('2192334455', '22933445566').for(:phone) }
    it { is_expected.to_not allow_value('21223344a', '33445566').for(:phone) }
  end

  describe 'callbacks' do
    it 'normalize email' do
      user = build(:user, email: 'SOMETHING@gmail.com')

      expect { user.save! }.to change(user, :email).to('something@gmail.com')
    end

    it 'normalize phone number' do
      user = build(:user, phone: '(21) 9-3344-1235')

      expect { user.save! }.to change(user, :phone).to('21933441235')
    end
  end

  describe '#confirm_phone!' do
    subject(:user) { create(:user, phone: '(21) 988659250') }

    it 'generate a confirmation code and send the SMS to the user' do
      messages = double(create: true)
      twilio_client = double(Twilio::REST::Client, messages: messages)

      expect(Twilio::REST::Client).to receive(:new).and_return(twilio_client)
      expect(messages).to receive(:create).with(from: Rails.application.secrets.twilio_phone_number, to: '+5521988659250', body: /Utilize o código/)

      expect { user.confirm_phone! }.to change { user.reload.phone_confirmation_code }
    end
  end

  describe '#confirm_phone?' do
    subject(:user) { create(:user, phone_confirmed: false, phone_confirmation_code: '123456') }

    context 'with valid code' do
      it 'confirm the user phone number' do
        expect { user.confirm_phone?('123456') }.to change(user, :phone_confirmed).to(true)
        expect(user.phone_confirmation_code).to be_nil
      end
    end

    context 'with invalid code' do
      it 'do not confirm the user phone and mark it as invalid' do
        expect { user.confirm_phone?('23456') }.to_not change(user, :phone_confirmed).from(false)
        expect(user.phone_confirmation_code).to be_present
        expect(user.errors).to_not be_empty
      end
    end
  end

  describe '#push_notification', vcr: true do
    subject(:user) { create(:user, device_token: token) }

    context 'with valid device_token' do
      let(:token) { 'e4_aiIzKcl4:APA91bF8Q-PdWO5yYKA7KkFApiYGZx9Zu1abbHFqxL1Kv5RHror08ZPLD5GrxUQJ7Tq-l8pJ6doMBu7xf4zzgd7rIIMvpWIz-6jL0p-qp_bv7H_YYfADEZt2ZdN4lZicVbs--XcyRsbJ' }

      it 'send the notification' do
        expect do
          user.push_notification(title: 'Something', text: 'Something amazing!')
        end.to change(RailsPushNotifications::Notification, :count).by(1)

        notification = RailsPushNotifications::Notification.last
        expect(notification).to be_sent
        expect(notification).to_not be_failed
      end
    end

    context 'with invalid device_token'do
      let(:token) { 'wrong' }

      it 'do not send the notification' do
        expect do
          user.push_notification(title: 'Something', text: 'Something amazing!')
        end.to change(RailsPushNotifications::Notification, :count).by(1)

        notification = RailsPushNotifications::Notification.last
        expect(notification).to be_sent
        expect(notification).to be_failed
      end
    end

    context 'without device_token set' do
      let(:token) { nil }

      it 'do not send the notification' do
        expect_any_instance_of(RailsPushNotifications::GCMApp).to_not receive(:push_notifications)

        expect do
          response = user.push_notification(title: 'Something', text: 'Something amazing!')
          expect(response).to be_falsey
        end.to_not change(RailsPushNotifications::Notification, :count)
      end
    end
  end
end
