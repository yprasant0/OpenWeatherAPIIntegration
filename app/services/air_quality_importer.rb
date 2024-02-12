class AirQualityImporter
  def self.import_all_locations
    Location.find_each do |location|
      response = fetch_air_quality_for(location)

      if response.present?
        air_quality_data = parse_response(response)
        create_air_quality_record(location, air_quality_data) if air_quality_data
      else
        log_failure("Failed to fetch air quality for #{location.name}")
      end
    end
  end

  private

  def self.fetch_air_quality_for(location)
    AirQualityService.fetch_air_quality(location.latitude, location.longitude)
  end

  def self.parse_response(response)
    data = response.parsed_response
    return log_failure("Error parsing air quality response: Invalid format") unless data && data['list'] && data['list'].any?

    extract_air_quality_data(data['list'].first)
  end

  def self.create_air_quality_record(location, air_quality_data)
    location.air_qualities.create!(air_quality_data)
  rescue ActiveRecord::RecordInvalid => e
    log_failure("Error saving air quality data for #{location.name}: #{e.message}")
  end

  def self.extract_air_quality_data(data)
    {
      aqi: data['main']['aqi'],
      pm2_5: data['components']['pm2_5'],
      pm10: data['components']['pm10'],
      co: data['components']['co'],
      so2: data['components']['so2'],
      no2: data['components']['no2'],
      o3: data['components']['o3'],
      nh3: data['components']['nh3'],
      no: data['components']['no'],
      measured_at: data['dt'] # Unix timestamp of the time when the data was measured
    }
  end

  def self.log_failure(message)
    Rails.logger.error message
  end
end


