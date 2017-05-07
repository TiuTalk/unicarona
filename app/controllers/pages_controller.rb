class PagesController < ApplicationController
  def home
    @routes = Route.enabled.order(created_at: :desc).limit(10)
  end
end
