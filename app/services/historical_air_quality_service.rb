class HistoricalAirQualityService < BaseApiService
  # Inherits from BaseApiService to use its HTTP request capabilities
  base_uri ENV['AIR_QUALITY_HISTORY_API']
  def self.fetch_and_store_history(months_back: 12, days_from_start: 10)
    Location.find_each(batch_size: 1000) do |location|
      start_date = months_back.months.ago.beginning_of_month.to_date
      (start_date..Date.today).select { |d| d.day == 1 }.each do |first_day_of_month|
        day_of_the_month = first_day_of_month + days_from_start.days
        end_point = '/history'
        query = query_options(location, first_day_of_month, day_of_the_month)
        response = fetch_data(base_uri + end_point, method: :get, options: { query: query })

        if response && response.success?
          air_quality_records = parse_air_quality_data(location, response)
          AirQuality.insert_all(air_quality_records)
        else
          log_and_record_failure(location, query, response)
        end
      end
    end
  end

  private

  def self.query_options(location, first_day_of_month, day_of_the_month)
    {
      lat: location.latitude,
      lon: location.longitude,
      start: first_day_of_month.to_time.to_i,
      end: day_of_the_month.to_time.to_i,
      appid: open_weather_api_key
    }
  end

  def self.parse_air_quality_data(location, response)
    data = response.parsed_response
    return unless data && data['list'] && data['list'].any?

    air_quality_list = data['list']
    air_quality_list.map do |air_quality|
      {
        aqi: air_quality['main']['aqi'],
        pm2_5: air_quality['components']['pm2_5'],
        pm10: air_quality['components']['pm10'],
        co: air_quality['components']['co'],
        so2: air_quality['components']['so2'],
        no2: air_quality['components']['no2'],
        o3: air_quality['components']['o3'],
        measured_at: Time.at(air_quality['dt']).utc,
        location_id: location.id,
        created_at: Time.now,
        updated_at: Time.now
      }
    end
  end

  def self.log_and_record_failure(location, query, response)
    Rails.logger.error "Failed to fetch historical air quality for #{location.name}. HTTP Status: #{response.code}, Body: #{response.body}"
    FailedRequest.create!(query_params: query, request_type: 'Historical Air Quality', status: 'failed', error_message: response.message, created_at: Time.current, updated_at: Time.current)
  end

  def self.open_weather_api_key
    ENV['OPEN_WEATHER_MAP_API_KEY']
  end
end
