module RatingAverage
    extend ActiveSupport::Concern

    # metodi laskee ratingien keskiarvon
    def average_rating
        sum = 0
        ratings = self.ratings
        if ratings.empty?
            return sum
        end
        sum = ratings.reduce(0) {|t, rating| t + rating.score}
        return sum*1.0/ratings.size
    end

end