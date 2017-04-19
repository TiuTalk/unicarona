class RoutesController < ApplicationController
  before_action :require_login
  before_action :set_route, only: [:show, :edit, :update, :destroy]

  def index
    @routes = current_user.routes.all
  end

  def show
  end

  def new
    @route = current_user.routes.new
  end

  def edit
  end

  def create
    @route = current_user.routes.new(route_params)

    if @route.save
      redirect_to @route, notice: 'Route was successfully created.'
    else
      render :new
    end
  end

  def update
    if @route.update(route_params)
      redirect_to @route, notice: 'Route was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @route.destroy
    redirect_to routes_url, notice: 'Route was successfully destroyed.'
  end

  private

  def set_route
    @route = current_user.routes.find(params[:id])
  end

  def route_params
    params.require(:route).permit(:origin, :destination)
  end
end
