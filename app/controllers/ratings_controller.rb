class RatingsController < ApplicationController

    # GET /ratings
    # GET /ratings.json
    def index
        @ratings = Rating.all
    end
end