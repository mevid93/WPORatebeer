class Beer < ApplicationRecord
  include RatingAverage
  extend Top

  validates :name, presence: true
  validates :style_id, presence: true

  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  # oluen paranneltu merkkijonoesitys
  def to_s
    "#{name} (#{Brewery.find(brewery_id).name})"
  end

  def average
    return 0 if ratings.empty?

    ratings.map(&:score).sum / ratings.count.to_f
  end
end
