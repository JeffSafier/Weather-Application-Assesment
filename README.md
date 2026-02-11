Weather-Application-Assesment
Weather Forecast Technical Assessment

A Ruby on Rails application that retrieves and caches weather forecasts based on user-provided addresses. Built with a focus on Object-Oriented Design, Service-Oriented Architecture, and Production-Level Best Practices.

Address Lookup: Converts plain-text addresses into geographic coordinates and Zip Codes.

Weather Data: Provides current temperature, high/lows, and a 10-day extended forecast.

Smart Caching: Forecasts are cached by Zip Code for 30 minutes.

Cache Indicator: UI clearly identifies if data is "Live" or retrieved from the "Cache".

Robust Testing: High test coverage using RSpec and WebMock.

Object Decomposition & Architecture
To ensure the codebase remains maintainable and scalable, I have decomposed the logic into specific functional areas:

1. Service Objects (The "Logic")
Climate::ForecastService: It handles the "check cache vs. call API" flow, and the actual call to the API

Locator::GeocodeService: Encapsulates external geocoding. It translates user input into the coordinates required by weather providers.

2. Value Objects
Climate::DailyWeather (Model): Instead of passing messy API hashes to the view, this bbject normalizes the data. It provides a clean interface (e.g., result[:data]["days"] ) and encapsulates data transformation logic.

3. Caching Layer
Uses Rails.cache with a 30-minute Expiration

Key Design Choice: Caching is performed by Zip Code rather than full address string to increase cache hit rates (e.g., "123 Main St, 90210" and "90210" will share the same cached weather data).

Design Patterns Applied
Service Pattern: Keeps business logic out of models and controllers, facilitating easier unit testing.

Decorator/View Model Pattern: The Climate::DailyWeather acts as a decorator for the raw API response, keeping the views logic-free.

Singleton/Configuration: API keys are managed via Rails Credentials to ensure security in production environments.

Scalability Considerations
Cache Store: Currently uses the default Memory Store. For a distributed production environment, this can be swapped to Redis in production.rb with zero changes to the service logic.

Background Processing: While currently synchronous for simplicity, the service-based architecture allows for easy migration to background jobs (Sidekiq/ActiveJob) if we wanted to pre-fetch data.

Testing Strategy
I utilized RSpec for testing.

Every service and model has a corresponding spec.

API Mocking: Used WebMock to prevent the test suite from making real network requests. This ensures tests are fast, reliable, and run offline.

Prerequisites
Ruby 3.4.1 

Rails 8.1.2

Setup
Clone the repository.

Run bundle install.

Add your API keys to config/credentials.yml.enc:

YAML - Add the api keys - First must sign up to these services

geocode_co:
  api_key: 
visual_crossing:
  api_key: 

Start the server: bin/rails s.

Visit localhost:3000.
