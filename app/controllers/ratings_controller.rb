class RatingsController < ApplicationController
  # GET /ratings
  # GET /ratings.json
  def index
    @ratings = Rating.all
  end

  # GET /ratings/new
  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  # POST /ratings
  def create
    # otetaan luotu reittaus muuttujaan
    @rating = Rating.create params.require(:rating).permit(:score, :beer_id)

    @rating.user = current_user if !current_user.nil?

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  # DELETE /ratings/1
  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
