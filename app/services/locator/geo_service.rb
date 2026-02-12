# frozen_string_literal: true

module Locator
  class GeoService

    GEOCODE_URL = "https://geocode.maps.co/search"

    def initialize(address)
      @address = address
      @api_key = Rails.application.credentials.geocode_co.api_key
    end

    def call
      return nil if @address.blank?

      data = JSON.parse(
        Net::HTTP.get(URI("#{GEOCODE_URL}?q=#{CGI.escape(@address)}&api_key=#{@api_key}"))
      ).first

      return nil if data.nil?

      {
        latitude:  data["lat"],
        longitude: data["lon"],
        zip_code:  data["address"]["postcode"].match(/^\d{5}/).to_s
      }
    end
  end
end


