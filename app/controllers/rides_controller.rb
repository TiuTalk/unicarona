class RidesController < ApplicationController
  before_action :require_login
  before_action :fetch_ride, only: [:show, :update]

  respond_to :json, :js, only: [:create]

  def index
    @rides_ongoing = current_user_rides.ongoing.order(created_at: :desc)
    @rides_taken = current_user.rides_taken.non_pending.order(created_at: :desc)
    @rides_given = current_user.rides_given.non_pending.order(created_at: :desc)
  end

  def show
    # Nothing here :)
  end

  def create
    @ride = current_user.rides_taken.pending.where(ride_params).first_or_initialize do |ride|
      ride.save && ride.notify_driver_of_new_ride
      ride
    end

    respond_with @ride, location: nil
  end

  def update
    @event = params[:event].to_sym
    allowed_events = current_user == @ride.driver ? %i(accept reject complete) : %i(cancel complete)

    if @event.in?(allowed_events) && @ride.send("may_#{@event}?")
      @ride.send("#{@event}!")
    end
  end

  private

  def current_user_rides
    Ride.where(driver: current_user).or(Ride.where(passenger: current_user))
  end

  def fetch_ride
    @ride = current_user_rides.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def ride_params
    params.require(:ride).permit(:route_id)
  end
end
