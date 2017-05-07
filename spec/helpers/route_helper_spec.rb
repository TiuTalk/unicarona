require 'rails_helper'

RSpec.describe RouteHelper, type: :helper do
  describe '#localized_weekdays' do
    let(:route) { build(:route, weekdays: %i(monday tuesday sunday)) }

    it 'return the list of translated weekdays' do
      expect(helper.localized_weekdays(route)).to eq(['Segunda-feira', 'Terça-feira', 'Domingo'])
      expect(helper.localized_weekdays(route, format: '%a')).to eq(['Seg', 'Ter', 'Dom'])
    end
  end
end
