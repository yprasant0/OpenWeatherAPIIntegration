class AirQuality < ApplicationRecord
  belongs_to :location

  validates_presence_of :aqi, :measured_at

  scope :average_aqi_per_month_per_location, -> {
    joins(:location)
      .select("locations.name AS location_name,
             EXTRACT(YEAR FROM measured_at) AS year,
             EXTRACT(MONTH FROM measured_at) AS month,
             AVG(aqi) AS average_aqi")
      .group(Arel.sql("locations.name, EXTRACT(YEAR FROM measured_at), EXTRACT(MONTH FROM measured_at)"))
      .order(Arel.sql("locations.name, EXTRACT(YEAR FROM measured_at), EXTRACT(MONTH FROM measured_at)"))
  }

  scope :average_aqi_per_location, -> {
    joins(:location)
      .select("locations.name AS location_name, AVG(aqi) AS average_aqi")
      .group("locations.name")
      .order("locations.name")
  }

  scope :average_aqi_per_state, -> {
    joins(:location)
      .select("locations.state, AVG(aqi) AS average_aqi")
      .group("locations.state")
      .order("locations.state")
  }
end
