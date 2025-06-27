require "httparty"
require "pry"
class WeatherService
  BASE_URL = "https://api.openweathermap.org/data/2.5/weather"

  def initialize(zip_code)
    @zip_code = zip_code
    @api_key = Rails.application.credentials.dig(:weather, :api_key)
  end

  def get_forecast
    response = HTTParty.get(BASE_URL, query: {
      zip: "#{@zip_code},in",
      units: "metric",
      appid: @api_key
    })

    if response.success?
      {
        temperature: response["main"]["temp"]
      }
    else
      raise StandardError, "Failed to fetch forecast: #{response.code}"
    end
  end
end
