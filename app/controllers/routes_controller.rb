class RoutesController < ApplicationController
  before_action :require_login, except: [:show]
  before_action :set_route, only: [:edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to root_path, alert: 'Rota não encontrada'
  end

  def search
    if request.post?
      @route = Route.new(route_search_params)
      @routes = Route.search(@route, Route.where.not(user: current_user))
    else
      @route = Route.new
    end
  end

  def index
    @routes = current_user.routes.all
  end

  def show
    @route = Route.find(params[:id])
  end

  def new
    @route = current_user.routes.new
  end

  def edit
  end

  def create
    @route = current_user.routes.new(route_params)

    if @route.save
      redirect_to routes_path, notice: 'Rota cadastrada com sucesso!'
    else
      render :new
    end
  end

  def update
    if @route.update(route_params)
      redirect_to routes_path, notice: 'Rota atualizada com sucesso!'
    else
      render :edit
    end
  end

  def destroy
    @route.destroy
    redirect_to routes_url, notice: 'Rota removida com sucesso!'
  end

  private

  def set_route
    @route = current_user.routes.find(params[:id])
  end

  def route_params
    params.require(:route).permit(:origin, :destination, :hour, :enabled, weekdays: [])
  end

  def route_search_params
    params.require(:route).permit(:origin, :destination)
  end
end
