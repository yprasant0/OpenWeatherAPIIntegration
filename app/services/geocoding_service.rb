class GeocodingService < BaseApiService
  base_uri ENV['GEOCODING_URI']
  def self.geocode(query_params)
    options = { query: { q: query_params[:q], appid: open_weather_api_key, limit: 1 } } # limit to 1 result
    end_point = '/direct'

    response = fetch_data(end_point, method: :get, options: options)
    validate_response(response, query_params)
  rescue GeocodingError => e
    # Handle specific geocoding errors
    Rails.logger.error e
    nil
  end

  private

  def self.validate_response(response, query_params)
    if response.blank? || !response.parsed_response.is_a?(Array) || response.parsed_response.empty?
      raise GeocodingDataError, "GeocodingService Error: Data Fetching failed for #{query_params[:q]}"
    end

    location_data = response.parsed_response.first
    unless location_data.key?('lat') && location_data.key?('lon')
      raise GeocodingDataError, "Incomplete location data for #{query_params[:q]}"
    end
    location_data
  end

  def self.open_weather_api_key
    ENV['OPEN_WEATHER_MAP_API_KEY']
  end
end

class GeocodingError < StandardError; end
class GeocodingDataError < GeocodingError; end
class GeocodingParsingError < GeocodingError; end

