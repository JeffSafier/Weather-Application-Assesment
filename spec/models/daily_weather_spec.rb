# frozen_string_literal: true

require "rails_helper.rb"

RSpec.describe Climate::DailyWeather, type: :model  do

  let(:weather_list) {
    [
      { "datetime" => "2026-02-10", "temp" => 98, "tempmin" => 60, "tempmax" => 100, "description" => "Rainy" },
      { "datetime" => "2026-02-11", "temp" => 20, "tempmin" => 10, "tempmax" => 22, "description" => "Snow" }
    ]
  }
  context "when creating instance of class" do
    it "will have have methods returning data correctly" do
      obj = described_class.new(weather_list[0])
      expect(obj.date).to be_eql("2026-02-10")
      expect(obj.temp).to be_eql(98)
      expect(obj.min_temp).to be_eql(60)
      expect(obj.max_temp).to be_eql(100)
      expect(obj.extended).to be_eql("Rainy")
    end
  end
  context "when creating array of class instances" do
    it "will have have methods returning data correctly" do
      obj = described_class.create_weather_objects(weather_list)
      expect(obj.size).to be_eql(2)
      expect(obj[0].date).to be_eql("2026-02-10")
      expect(obj[0].temp).to be_eql(98)
      expect(obj[0].min_temp).to be_eql(60)
      expect(obj[0].max_temp).to be_eql(100)
      expect(obj[0].extended).to be_eql("Rainy")
      expect(obj[1].date).to be_eql("2026-02-11")
      expect(obj[1].temp).to be_eql(20)
      expect(obj[1].min_temp).to be_eql(10)
      expect(obj[1].max_temp).to be_eql(22)
      expect(obj[1].extended).to be_eql("Snow")
    end
  end
end
