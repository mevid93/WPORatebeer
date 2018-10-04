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

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  # käyttäjän mieli oluttyyli
  def favorite_style
    return nil if ratings.empty?

    styles = ratings.map { |r| r.beer.style.name }.uniq
    favorite_style = nil
    max_average = 0
    styles.each { |style|
      average = style_average_rating(style)
      if average > max_average
        max_average = average
        favorite_style = style
      end
    }
    favorite_style
  end

  # metodi laskee keskiarvon käyttäjän tekemille arvosteluille tietylle olut tyylille
  def style_average_rating(style)
    return 0 if style.nil? || ratings.empty?

    ret = ratings.map { |r| [r.beer.style.name, r.score] if r.beer.style.name == style }.compact
    return 0 if ret.empty?

    ret.reduce(0) { |sum, indv| sum + indv[1] } / ret.length.to_f
  end

  # käyttäjän mielipanimo
  def favorite_brewery
    return nil if ratings.empty?

    breweries = ratings.map { |r| r.beer.brewery.id }.uniq
    favorite = nil
    max_average = 0
    breweries.each { |brewery_id|
      average = brewery_average_rating(brewery_id)
      if average > max_average
        max_average = average
        favorite = brewery_id
      end
    }
    favorite = Brewery.find(favorite)
  end

  # metodi laskee keskiarvon käyttäjän tekemille arvosteluille tietylle olut tyylille
  def brewery_average_rating(brewery_id)
    return 0 if brewery_id.nil? || ratings.empty?

    ret = ratings.map { |r| r.score if r.beer.brewery.id == brewery_id }.compact
    return 0 if ret.empty?

    ret.reduce(0, :+) / ret.length.to_f
  end
end
