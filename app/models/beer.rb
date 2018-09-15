class Beer < ApplicationRecord
    include RatingAverage

    belongs_to :brewery
    has_many :ratings, dependent: :destroy

    # oluen paranneltu merkkijonoesitys
    def to_s
        brewery = Brewery.find(self.brewery_id)
        "#{self.name} (#{brewery.name})"
    end

end
