require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations'

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
end
