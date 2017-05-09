require 'rails_helper'

RSpec.describe RidesController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in_as(user) }

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #create" do
    it "returns http success" do
      get :create
      expect(response).to have_http_status(:success)
    end
  end
end
