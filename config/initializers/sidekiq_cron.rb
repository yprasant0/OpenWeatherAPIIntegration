require 'sidekiq/cron/job'

Sidekiq::Cron::Job.create(
  name: 'AirQualityImporter - every 30 seconds',
  cron: '*/30 * * * * *', # This cron notation means every 30 seconds
  class: 'AirQualityImportJob'
)

# Sidekiq::Cron::Job.create(
#   name: 'AirQualityImportJob - every 1 hour',
#   cron: '0 * * * * ',
#   class: 'AirQualityImportJob'
# )
