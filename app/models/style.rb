class Style < ApplicationRecord
  include RatingAverage
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers
  validates :name, length: { minimum: 3, maximum: 30 }

  def self.top(var_n)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |b| -(b.average_rating || 0) }
    return [] if sorted_by_rating_in_desc_order.empty?

    result = sorted_by_rating_in_desc_order[0..var_n - 1]
    result.compact
  end
end
