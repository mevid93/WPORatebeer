class User < ApplicationRecord
  include RatingAverage

  validates :username, uniqueness: true,
                       length: { minimum: 3 }

  has_many :ratings # käyttäjällä on monta ratingia
end
