class WeatherService
  def initialize(zip_code)
    @zip_code = zip_code
  end

  def get_forecast
    {
      temperature: 72.5 # Stubbed response for test
    }
  end
end
