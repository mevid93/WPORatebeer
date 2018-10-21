class Style < ApplicationRecord
  include RatingAverage
  extend Top
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers
  validates :name, length: { minimum: 3, maximum: 30 }
end
