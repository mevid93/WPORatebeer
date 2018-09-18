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
    rating = Rating.create params.require(:rating).permit(:score, :beer_id)

    # talletetaan tehty reittaus sessioon
    session[:last_rating] = "#{rating.beer.name} #{rating.score} points"

    redirect_to ratings_path
  end

  # DELETE /ratings/1
  def destroy
    rating = Rating.find(params[:id])
    rating.delete
    redirect_to ratings_path
  end
end
