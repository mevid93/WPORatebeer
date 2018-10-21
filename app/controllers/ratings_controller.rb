class RatingsController < ApplicationController
  # GET /ratings
  # GET /ratings.json
  def index
    # top oluet, panimot, tyyli käyttäjät ja viimeaikaiset reittaukset on cachattu
    # tarkistetaan kullekkin erikseen onko fragemntti olemassa ja tarvittaessa noudetaan
    # expiroitunut tieto uudestaan
    @ratings_count = Rating.all.count if !request.format.html? || !fragment_exist?("ratings_count")
    @recent_ratings = Rating.recent if !request.format.html? || !fragment_exist?("recent_ratings")
    @top_beers = Beer.top 3 if !request.format.html? || !fragment_exist?("top_beers")
    @top_breweries = Brewery.top 3 if !request.format.html? || !fragment_exist?("top_breweries")
    @top_styles = Style.top 3 if !request.format.html? || !fragment_exist?("top_styles")
    @top_users = User.top 3 if !request.format.html? || !fragment_exist?("top_users")
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

    # seuraava rivi ei toiminut herokussa suoraan, vaan
    # vaadittiin nil? tarkastelu... ei kyllä mitään järkeä
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
