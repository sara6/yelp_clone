class ReviewsController < ApplicationController

before_action :authenticate_user!

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    if current_user.has_reviewed?(@restaurant)
      flash[:alert] = 'has reviewed this restaurant already'
      redirect_to restaurants_path
    end
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.new(review_params)

    if @review.save
      redirect_to restaurants_path
    else
        flash[:alert] = 'has reviewed this restaurant already'
        redirect_to restaurants_path
    end
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating).merge(user: current_user)
  end

  def destroy
    @review = Review.find(params[:id])
      if current_user.reviews.include?(@review)
        @review.destroy
      # if @review.owned_by?(current_user)
      #   @review.destroy
        flash[:notice] = "Review deleted"
      else
        flash[:notice] = "Cannot delete review you have not added"
      end
      redirect_to restaurants_path
  end

end
