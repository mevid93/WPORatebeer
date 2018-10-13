class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  validate :password_validation

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  # testi tarkastaa, että salasana on vähintään 4 merkkiä pitkä,
  # sisältää yhden ison kirjaimen A-Z ja vähintään yhden numeron
  def password_validation
    errors.add(:password, "must be at least 4 characters long") if password.nil? || password.length < 4

    errors.add(:password, "must contain at least 1 capital letter") if password.nil? || password !~ /\A([a-zA-Z]|\d)*[A-Z]([a-zA-Z]|\d)*\z/

    errors.add(:password, "must contain at least 1 digit") if password.nil? || password !~ /\A([a-zA-Z]|\d)*[\d]([a-zA-Z]|\d)*\z/
  end

  # käyttäjän lempiout
  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  # käyttäjän lempityyli
  def favorite_style
    favorite(:style)
  end

  # käyttäjän mielipanimo
  def favorite_brewery
    favorite(:brewery)
  end

  def favorite(groupped_by)
    return nil if ratings.empty?

    grouped_ratings = ratings.group_by{ |r| r.beer.send(groupped_by) }
    averages = grouped_ratings.map do |group, ratings|
      { group: group, score: average_of(ratings) }
    end

    averages.max_by{ |r| r[:score] }[:group]
  end

  def average_of(ratings)
    ratings.sum(&:score).to_f / ratings.count
  end

  def self.top(var_n)
    sorted_by_rating_in_desc_order = User.all.sort_by{ |u| -u.ratings.count }
    return [] if sorted_by_rating_in_desc_order.empty?

    result = sorted_by_rating_in_desc_order[0..var_n - 1]
    result.compact
  end
end
