json.array! @active_breweries, partial: 'breweries/brewery', as: :brewery
json.array! @retired_breweries, partial: 'breweries/brewery', as: :brewery
