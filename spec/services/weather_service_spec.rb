require 'rails_helper'
RSpec.describe WeatherService do
  let(:zip_code) { '452009' } # Indore ZIP
  let(:country_code) { 'in' } # Default to India

  subject(:service) { described_class.new(zip_code, country_code) }

  describe "#get_forecast", :vcr do
    it "returns the current temperature for a valid zip code" do
      result = service.get_forecast

      expect(result).to include(:temperature)
      expect(result[:temperature]).to be_a(Numeric)
    end
  end

  describe "caching behavior", :vcr do
    it "caches the forecast for 30 minutes by zip code" do
      Rails.cache.clear

      # First call
      result_1 = service.get_forecast

      allow(HTTParty).to receive(:get).and_call_original

      # Second call - should use cache, so HTTParty.get should not be called
      result_2 = service.get_forecast

      expect(result_2).to eq(result_1)
      expect(HTTParty).to have_received(:get).once
    end
  end
end
