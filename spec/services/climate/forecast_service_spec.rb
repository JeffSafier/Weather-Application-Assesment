# frozen_string_literal: true

require "rails_helper.rb"

RSpec.describe Climate::ForecastService do

  let(:address) { "Bayside New York, 11364"}
  let(:zip) { "11364" }
  subject { described_class.new(address)}

  before do
    allow_any_instance_of(Locator::GeoService).to receive(:call).and_return(
      {latitude: "40.7684351", longitude: "-73.7770774", zip_code: "11364"}
    )
    stub_request(:get, /weather.visualcrossing.com/)
      .to_return(status: 200, body:
        { days: [
          { "datetime": "2026-02-11", "temp": 98.6, "temp_min": 72, "temp_max": 100 },
          { "datetime": "2026-02-12", "temp": 32, "temp_min": 5, "temp_max": 40 }
          ] }.to_json)
  end


  context 'testing cache' do
    it 'caches the result by text and zip code' do
      expect(Rails.cache).to receive(:write).with("Apple App/#{zip}", any_args)
      described_class.new(address).call
    end
    it "returns a flag that we arent using cache the for time called" do
      # First call (uncached)
      result1 = subject.call
      expect(result1[:cached]).to be false
    end
    it "returns a flag that we are using cache for second time" do
      # call (uncached)
      result1 = subject.call
      allow(Rails.cache).to receive(:read).and_return({ some: 'data' })
      # call cached
      result2 = subject.call
      expect(result2[:cached]).to be true
    end
    context "when having over a 30 minute gap in service calls " do
      it "flag will returned that we are no using cache" do
        travel_to Time.new(2025, 01, 01, 12, 0) do
          result1 = subject.call
        end
        result1 = subject.call
        expect(result1[:cached]).to be false
      end
    end
  end
end
