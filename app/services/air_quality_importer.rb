class AirQualityImporter
  BATCH_SIZE = 10 # Define an appropriate batch size

  def self.import_for_all_locations
    today = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    cache_key = "existing_air_quality_#{today}_location_ids"

    # Fetch or initialize the cache for today's processed locations
    processed_location_ids = Rails.cache.fetch(cache_key, expires_in: 24.hours) { [] }

    # Determine which locations need processing
    locations_to_process = Location.where.not(id: processed_location_ids)

    locations_to_process.find_in_batches(batch_size: BATCH_SIZE) do |batch|
      batch.each do |location|
        air_quality_data = AirQualityService.fetch_air_quality(location.latitude, location.longitude)
        if air_quality_data && air_quality_data.success?
          save_air_quality_data(location, air_quality_data)
          # Update the cache with the newly processed location ID
          processed_location_ids << location.id
        end
      end

      # Update the cache for the batch
      Rails.cache.write(cache_key, processed_location_ids, expires_in: 24.hours)
    end
  end

  private

  def self.save_air_quality_data(location, data)
    # Assuming a simplified data structure for demonstration
    AirQuality.create!(
      location: location,
      aqi: data['list'].first['main']['aqi'],
      pm2_5: data['list'].first['components']['pm2_5'],
      pm10: data['list'].first['components']['pm10'],
      co: data['list'].first['components']['co'],
      so2: data['list'].first['components']['so2'],
      no2: data['list'].first['components']['no2'],
      o3: data['list'].first['components']['o3'],
      measured_at: Time.current
    )
  end
end
