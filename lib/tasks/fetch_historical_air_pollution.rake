namespace :air_quality do
  desc "Fetch and store historical air quality data"
  task :fetch_history, [:months_back, :days_from_start] => :environment do |t, args|
    months_back = args[:months_back].to_i # Default to 12 months if not specified
    days_from_start = args[:days_from_start].to_i # Default to 10 days if not specified

    puts "Fetching historical air quality data starting from #{months_back} months ago, for #{days_from_start} days from the start of each month."
    HistoricalAirQualityService.fetch_and_store_history(months_back: months_back, days_from_start: days_from_start)
  end
end
