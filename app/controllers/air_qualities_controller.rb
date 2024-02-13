class AirQualitiesController < ApplicationController
  def index
    @avg_aqi_per_month_location = AirQuality.average_aqi_per_month_per_location
    @avg_aqi_per_location = AirQuality.average_aqi_per_location
    @avg_aqi_per_state = AirQuality.average_aqi_per_state
  end
end

