class PlacesController < ApplicationController
  def index
  end

  def show
    @place = BeermappingApi.location_by_id(params[:id])
    if @place.nil?
      # tämän ei pitäisi olla periaatteessa mahdollista
      redirect_to places_path, notice: "Location could not be fetched (no match for id)"
    else
      render :show
    end
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    @city = params[:city]
    @weather = ApixuApi.weather_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end
end
