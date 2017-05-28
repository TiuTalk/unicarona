class RidesController < ApplicationController
  before_action :require_login

  respond_to :json, :js, only: [:create]

  def index
    @rides_taken = current_user.rides_taken.order(created_at: :desc)
    @rides_given = current_user.rides_given.order(created_at: :desc)
  end

  def show
    @ride = current_user_rides.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def create
    @ride = current_user.rides_taken.pending.where(ride_params).first_or_initialize do |ride|
      ride.save && ride.notify_driver
      ride
    end

    respond_with @ride, location: nil
  end

  private

  def current_user_rides
    Ride.where(driver: current_user).or(Ride.where(passenger: current_user))
  end

  def ride_params
    params.require(:ride).permit(:route_id)
  end
end
