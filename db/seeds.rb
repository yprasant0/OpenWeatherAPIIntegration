# Fetch long and lat for cities in India and store them in DB

# indian_cities = %w[Nagpur Delhi Bangalore Hyderabad Ahmedabad Chennai Kolkata Pune Jaipur Lucknow Kanpur Mumbai Indore Thiruvananthapuram Bhopal Visakhapatnam Patna Ludhiana Agra Varanasi]

indian_cities = %w[Delhi Mumbai]
puts 'Fetching and creating locations... \n'
locations_to_insert = []
failed_requests_to_insert = []

indian_cities.each do |city_name|
  query_params = { q: city_name } # params used for the request
  begin
    if Location.find_by(name: city_name).present?
      puts "Location #{city_name} already exists"
      next
    else
      location = GeocodingService.geocode(query_params)

      if location.present?
        locations_to_insert << { name: city_name, latitude: location['lat'], longitude: location['lon'], state: location['state'], country: location['country'], created_at: Time.current, updated_at: Time.current }
      else
        failed_requests_to_insert << { query_params: query_params, request_type: 'Geocoding', status: 'failed', error_message: 'Geocoding returned no results', created_at: Time.current, updated_at: Time.current }
      end
    end
  rescue => e
    failed_requests_to_insert << { query_params: query_params, request_type: 'Geocoding', status: 'failed', error_message: e.message, created_at: Time.current, updated_at: Time.current }
    Rails.logger.error "Error  #{city_name}: #{e.message}"
  end
end

#Bulk insertions
ActiveRecord::Base.transaction do
  Location.insert_all!(locations_to_insert) if locations_to_insert.any?
  FailedRequest.insert_all!(failed_requests_to_insert) if failed_requests_to_insert.any?
end


