class AirQualityService < BaseApiService
  base_uri ENV['CURRENT_AIR_POLLUTION']

  def self.fetch_air_quality(latitude, longitude)
    options = query_options(latitude, longitude)
    endpoint = "/air_pollution"
    response = fetch_data(base_uri + endpoint, method: :get, options: options)
    handle_response(response, options)
  rescue StandardError => e
    log_and_record_failure(e.message, options)
    nil
  end

  private

  def self.query_options(latitude, longitude)
    { query: { lat: latitude, lon: longitude, appid: open_weather_api_key } }
  end

  def self.handle_response(response, options)
    if response.present?
      Rails.logger.info "Air quality data fetched successfully for #{options[:query][:lat]}, #{options[:query][:lon]}"
      response
    else
      log_and_record_failure("Failed to fetch air quality data: #{response.message}", options)
      nil
    end
  end

  def self.log_and_record_failure(error_message, options)
    Rails.logger.error error_message
    FailedRequest.create!(query_params: options[:query], request_type: 'Air Quality', status: 'failed',
                          error_message: error_message, created_at: Time.current, updated_at: Time.current)
  end

  def self.open_weather_api_key
    ENV['OPEN_WEATHER_MAP_API_KEY']
  end
end
