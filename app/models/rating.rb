class Rating < ApplicationRecord
    belongs_to :beer

    # olion parempi merkkijonoesitys
    def to_s
        beer = Beer.find(beer_id)
        "#{beer.name} #{score}"
    end


end
