# frozen_string_literal: true

#DailyWeather is just a regular ruby class that will eventually make the view cleaner
module Climate
  class DailyWeather
    attr_reader :date, :temp, :min_temp, :max_temp, :extended

    # creating an aray of instances - like a factory
    def self.create_weather_objects(list)
      list.map { |obj| new(obj) }
    end

    def initialize(day)
      @date = day["datetime"]
      @temp = day["temp"]
      @min_temp = day["tempmin"]
      @max_temp = day["tempmax"]
      @extended =  day["description"]

    end
  end
end
