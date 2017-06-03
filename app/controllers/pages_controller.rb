class PagesController < ApplicationController
  def home
    @routes = Route.enabled.order(created_at: :desc).limit(10)
    @routes = @routes.where.not(user: current_user) if signed_in?
  end
end
