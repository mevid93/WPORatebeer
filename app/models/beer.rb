class Beer < ApplicationRecord
  include RatingAverage

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

  def self.top(var_n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating || 0) }
    return [] if sorted_by_rating_in_desc_order.empty?

    result = sorted_by_rating_in_desc_order[0..var_n - 1]
    result.compact
  end
end
