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
    errors.add(:password, "must be at least 4 characters long") if password.length < 4

    errors.add(:password, "must contain at least 1 capital letter") if password !~ /\A([a-zA-Z]|\d)*[A-Z]([a-zA-Z]|\d)*\z/

    errors.add(:password, "must contain at least 1 digit") if password !~ /\A([a-zA-Z]|\d)*[\d]([a-zA-Z]|\d)*\z/
  end
end
