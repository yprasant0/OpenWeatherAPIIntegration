require 'httparty'

class AirQualityService
  include HTTParty
  base_uri 'http://api.openweathermap.org/data/2.5/air_pollution'

  def initialize
    @api_key = env['OPEN_WEATHER_MAP_API_KEY']
  end

  def fetch_for_location(lat, lon)
    options = { query: { lat: lat, lon: lon, appid: @api_key } }
    self.class.get('', options)
  end
end

