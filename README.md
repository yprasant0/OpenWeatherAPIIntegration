# OpenWeatherAPIIntegration
This project aims to target the following:

Ruby on Rails application using PostgreSQL as the database.
Maintaining a list of 20 locations across India along with their location info - latitude, longitude.
Utilizing the OpenWeatherMap Air Pollution API to fetch current air pollution data for the locations.
Creating an importer to parse and save the fetched data into the database, including air quality index (AQI), pollutant concentrations, and location details.
Implementing a scheduled task to run the importer every 1 hour used Sidekiq (for demo purposes time interval is set to every 30s)
Use RSpec to write unit tests for the application (Used minitest instead)
Write queries to: a. Calculate the average air quality index per month per location. b. Calculate the average air quality index per location. c. Calculate the average air quality index per state.
Three apis from Openweathermap has been used
OpenWeatherMap Air Pollution API https://openweathermap.org/api/air-pollution
OpenWeatherMap Air Pollution History API https://openweathermap.org/api/air-pollution#history
OpenWeatherMap Geocoding API https://openweathermap.org/api/geocoding-api

Ruby version - ruby 3.1.2p20
Rails version - rails 7.0.8

Getting Started
Clone the git repo
Once ruby and rails is setup on your system, install redis as well
sudo apt-get install redis (to install redis locally)
Run - bundle install/update to install all the gems
Run rake db:create, rake db:migrate to initialize the database for the RoR application


Runnig the application
Once the basic setup and installation is done
run rake db:seed to populate the databse with some dummy cities, the seeds code use the GEOCODING API
Open 3 seperate terminals for 3 servers Rails, Redis and Sidekiq
Rails Server : rails s (in terminal 1)
Redis : redis-server (in terminal 2)
Sidekiq: bundle exec sidekiq -C config/sidekiq.yml (in terminal 3)

To check the queries
run the rails server
http://localhost:3000/air_qualities to view the queries



