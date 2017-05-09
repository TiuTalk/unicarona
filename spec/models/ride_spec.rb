require 'rails_helper'

RSpec.describe Ride, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:driver).class_name(User).inverse_of(:rides_given) }
    it { is_expected.to belong_to(:passenger).class_name(User).inverse_of(:rides_taken) }
    it { is_expected.to belong_to(:route).inverse_of(:rides) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:driver) }
    it { is_expected.to validate_presence_of(:passenger) }
    it { is_expected.to validate_presence_of(:route) }
  end
end
