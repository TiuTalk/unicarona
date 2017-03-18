require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET #home' do
    it 'return OK' do
      get :home
      expect(response).to be_ok
    end
  end
end
