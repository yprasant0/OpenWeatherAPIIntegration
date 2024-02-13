OpenWeatherAPIIntegration
OpenWeatherAPIIntegration is a Ruby on Rails application designed to leverage the OpenWeatherMap APIs for fetching and analyzing air pollution data across various locations in India. It features real-time data fetching, scheduled updates, and comprehensive analytics on air quality indices.

Features
Rails Application: Built with Ruby on Rails and PostgreSQL.
Data Fetching: Utilizes OpenWeatherMap APIs for current and historical air pollution data.
Scheduled Updates: Implements Sidekiq for regular data updates.
Comprehensive Analytics: Offers detailed analysis on air quality indices.
Prerequisites
Before you begin, ensure you have installed:

Ruby (version 3.1.2)
Rails (version 7.0.8)
PostgreSQL
Redis
Getting Started
Follow these steps to get your application up and running:

1. Clone the Repository
   git clone <repository-url>
   cd OpenWeatherAPIIntegration
2. Install Dependencies
   bundle install
3. Setup Database
   rails db:create
   rails db:migrate
4. Seed the Database
   To populate the database with initial data:


    rails db:seed
    Running the Application
    To run the application, you will need to start the Rails server, Redis, and Sidekiq in separate terminals:
    

      rails s
      redis-server
      bundle exec sidekiq -C config/sidekiq.yml
      Viewing the Data
      Navigate to http://localhost:3000/air_qualities in your web browser to view and analyze the air quality data.

Data Analysis Queries

The application supports various queries for data analysis, including:

Average air quality index (AQI) per month per location.
Average AQI per location.
Average AQI per state.
Technologies Used

OpenWeatherMap API: For fetching air pollution data.
Ruby on Rails: Application framework.
PostgreSQL: Database management.
Sidekiq: Background processing.
RSpec: Testing suite (Note: initially mentioned, but Minitest is used).