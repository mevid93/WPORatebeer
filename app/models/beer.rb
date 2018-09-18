class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  # oluen paranneltu merkkijonoesitys
  def to_s
    "#{name} (#{Brewery.find(brewery_id).name})"
  end

  def average
    return 0 if ratings.empty?

    ratings.map(&:score).sum / ratings.count.to_f
  end
end
