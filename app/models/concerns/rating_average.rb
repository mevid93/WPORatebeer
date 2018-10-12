module RatingAverage
  extend ActiveSupport::Concern

  # metodi laskee ratingien keskiarvon
  def average_rating
    sum = 0
    ratings = self.ratings
    return sum if ratings.empty?

    sum = ratings.reduce(0) { |t, rating| t + rating.score }
    (sum * 1.0 / ratings.size).round(2)
  end
end
