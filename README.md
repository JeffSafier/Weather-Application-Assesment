# README

Weather Forecast Technical Assessment
A Ruby on Rails application that retrieves and caches weather forecasts based on user-provided addresses. Built with a focus on Object-Oriented Design, Service-Oriented Architecture, and Production-Level Best Practices.

# Features
Locator::GeoService Converts plain-text addresses into geographic coordinates and Zip Codes.

Climate::ForecastService: Provides current temperature, high/lows, and a 5-day extended forecast.

Smart Caching: Forecasts are cached by Zip Code for 30 minutes.

Cache Indicator: UI clearly identifies if data is "Live" or retrieved from the "Cache".

Robust Testing: High test coverage using RSpec and WebMock.

# Object Decomposition & Architecture
To ensure the codebase remains maintainable and scalable, I have decomposed the logic into specific functional areas:

1. Service Objects (The "Logic")
Climate::ForecastService: The primary orchestrator. It handles the "check cache vs. call API" flow.

Locator::GeoService: Encapsulates the complexity of external geocoding. It translates user input into the coordinates required by weather providers.

2. Models
Cimate::DailyWeather: Instead of passing messy API hashes to the view, this objectnormalizes the data. It provides a clean interface (e.g., result[:days]["temp"]) and encapsulates data transformation logic.

3. Caching Layer
Uses Rails.cache with a 30-minute TTL.Expiry

Key Design Choice: Caching is performed by Zip Code rather than full address string to increase cache hit rates (e.g., "123 Main St, 90210" and "90210" will share the same cached weather data).

Design Patterns Applied
Service Pattern: Keeps business logic out of models and controllers, facilitating easier unit testing.

Decorator/View Model Pattern: The DailyWeather acts as a decorator for the raw API response, keeping the views logic-free.

Singleton/Configuration: API keys are managed via Rails Credentials to ensure security in production environments.

Scalability Considerations
Cache Store: Currently uses the default Memory Store. For a distributed production environment, this can be swapped to Redis in production.rb with zero changes to the service logic.

Background Processing: While currently synchronous for simplicity, the service-based architecture allows for easy migration to background jobs (Sidekiq/ActiveJob) if we wanted to pre-fetch data.

# Testing Strategy
I utilized RSpec for testing.

Unit Tests: Every service and model has a corresponding spec.

API Mocking: Used WebMock to prevent the test suite from making real network requests. This ensures tests are fast, reliable, and run offline.

To run the tests:

Bash
bundle exec rspec
# Getting Started

Prerequisites
Ruby 3.4.1

Rails 8.1

Setup
Clone the repository.

Run bundle install.

Add your API keys to config/credentials.yml.enc:

YAML
visual_crossing:
  api_key: your_key_here
geocode_co
  api_key: your_key_here
  
Start the server: bin/rails s.

Visit localhost:3000.
