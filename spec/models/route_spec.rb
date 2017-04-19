require 'rails_helper'

RSpec.describe Route, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:routes) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:origin) }
    it { is_expected.to validate_presence_of(:destination) }
    it { is_expected.to validate_presence_of(:hour) }
    it { is_expected.to validate_presence_of(:origin_latitude) }
    it { is_expected.to validate_presence_of(:origin_longitude) }
    it { is_expected.to validate_presence_of(:destination_latitude) }
    it { is_expected.to validate_presence_of(:destination_longitude) }
  end
end
