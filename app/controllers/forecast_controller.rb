# frozen_string_literal: true

class ForecastController < ApplicationController

  def index
    # Only call service when post message, so the initial get will just display the screen
    if request.post?
      begin
        #create a service instance and execute the call method.
        # The result will be the data and the state of the cache or an error
        result = Climate::ForecastService.new(params[:address]).call

        #in case of an eror from our application we will just have it display in the flash
        if result[:error]
          flash.now[:alert] = result[:error]
        else
          @is_cached = result[:cached] #set is_cached to state of cached for view
          # create an array of DailyWeather objects
          @daily_weather_objects = Climate::DailyWeather.create_weather_objects(result[:data]["days"])
        end
      rescue StandardError=>e #if standarerror thrown from either api we will log it
        logger.error e.message
        flash.now[:alert] = e.message
      end
    end
  end
end
