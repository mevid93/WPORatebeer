class ApixuApi
  def self.weather_in(city)
    city = city.downcase
    city_weather = "weather@#{city}"
    # city ei keplaa avaimeksi, sillä se on avaimena jo kaupungille
    Rails.cache.fetch(city_weather) { get_weather_in(city) }
  end

  def self.get_weather_in(city)
    url = "http://api.apixu.com/v1/current.json?key=#{key}&q="

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    weather = response.parsed_response

    return nil if weather.is_a?(Hash) && weather["error"]

    Weather.new(weather['current']) if weather.is_a?(Hash)
  end

  def self.key
    raise "APIXU_APIKEY env variable not defined" if ENV['APIXU_APIKEY'].nil?

    ENV['APIXU_APIKEY']
  end
end
