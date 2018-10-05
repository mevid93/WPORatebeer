class Style < ApplicationRecord
  has_many :beers, dependent: :destroy
  validates :name, length: { minimum: 3, maximum: 30 }
end
