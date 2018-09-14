class Beer < ApplicationRecord
    belongs_to :brewery
    has_many :ratings

    # laske oluen ratingien keskiarvon
    def average_rating
        sum = 0
        ratings = Rating.where beer_id: self.id
        if ratings.empty?
            return sum
        end
        sum = ratings.reduce(0) {|t, rating| t + rating.score}
        return sum*1.0/ratings.size
    end

    # oluen paranneltu merkkijonoesitys
    def to_s
        brewery = Brewery.find(self.brewery_id)
        "#{self.name} (#{brewery.name})"
    end

end
