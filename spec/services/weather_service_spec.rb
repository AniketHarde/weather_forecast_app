require 'rails_helper'
RSpec.describe WeatherService do
  let(:zip_code) { '452009' } # Indore ZIP

  subject(:service) { described_class.new(zip_code) }

  describe "#get_forecast", :vcr do
    it "returns the current temperature for a valid zip code" do
      result = service.get_forecast

      expect(result).to include(:temperature)
      expect(result[:temperature]).to be_a(Numeric)
    end
  end
end
