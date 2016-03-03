class RestaurantsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user_id = current_user.id
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.owned_by?(current_user)
      @restaurant.update(restaurant_params)
    else
      flash[:notice] = "Unauthorised edit"
    end
    redirect_to restaurants_path

  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    byebug
    if @restaurant.owned_by?(current_user)
      byebug
      @restaurant.destroy
      flash[:notice] = "Restaurant deleted successfully"
    else
      byebug
      flash[:notice] = "Cannot delete restaurant you have not added"
    end
    byebug
    redirect_to restaurants_path
  end

end
