class RidesController < ApplicationController
  before_action :require_login, except: [:show]

  respond_to :json, :js

  def create
    @ride = current_user.rides_taken.pending.where(ride_params).first_or_initialize do |ride|
      ride.save && ride.notify_driver
      ride
    end

    respond_with @ride, location: nil
  end

  private

  def ride_params
    params.require(:ride).permit(:route_id)
  end
end
