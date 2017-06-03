class PagesController < ApplicationController
  def home
    @routes = Route.enabled.order(created_at: :desc).limit(10)
    @routes = @routes.where.not(user: current_user) if signed_in?

    if params[:latitude].present?
      origin = [params[:latitude], params[:longitude]]
      range = ENV.fetch('DISTANCE_RANGE', 1.5).to_f

      @routes = @routes.near(origin, range * 2, unit: :km, latitude: :origin_latitude, longitude: :origin_longitude)
    end
  end
end
