class RestaurantsController < ApplicationController

  def index
    @restaurants = Restaurantall
  end



end
