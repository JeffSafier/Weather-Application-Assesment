# frozen_string_literal: true

module Climate
  class ForecastService

    FORECAST_URL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline"
    EXPIRES_IN= 30.minutes

    def initialize(address)
      @address = address
      # get api key for
      @api_key = Rails.application.credentials.visual_crossing.api_key
    end

    def call
      @geo_data = Locator::GeoService.new(@address).call
      return { error: "Latitude/Longitude not found" } if @geo_data.blank?

      weather = Rails.cache.read(cached_key)
      return { data: weather, cached: true } if weather

      weather = JSON.parse(Net::HTTP.get(URI("#{FORECAST_URL}/#{latitude},#{longitude}/#{start_date}/#{end_date}?key=#{@api_key}")))
      if weather
        Rails.cache.write(cached_key, weather, expires_in: EXPIRES_IN)
        { data: weather, cached: false }
      else
        { error: "Error with Visual Crossing API"}
      end
    end

    private

    def longitude
       @geo_data[:longitude]
    end

    def latitude
      @geo_data[:latitude]
    end

    def zip_code
      @geo_data[:zip_code]
    end

    def start_date
      Date.today.strftime("%Y-%m-%d")
    end

    def end_date
      (Date.today+9.days).strftime("%Y-%m-%d")
    end

    def cached_key
      "Apple App/#{zip_code}" if @geo_data
    end
  end
end
