class AirQualityImportJob < ApplicationJob
  queue_as :default

  def perform(*args)
    AirQualityImporter.import_all_locations
  end
end
