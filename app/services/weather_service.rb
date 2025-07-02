class WeatherService
  BASE_URL = "https://api.openweathermap.org/data/2.5/weather"
  CACHE_PREFIX = "forecast:zip:"
  CACHE_EXPIRY = 30.minutes
  DEFAULT_UNITS = "metric"
  TIMEZONE = "Asia/Kolkata"

  def initialize(lat: nil, lon: nil, zip_code: nil, country_code: nil)
    @lat = lat
    @lon = lon
    @zip_code = zip_code
    @country_code = country_code
    @api_key = Rails.application.credentials.dig(:weather, :api_key)
  end

  def get_forecast
    cache_key = "#{CACHE_PREFIX}#{@zip_code}"
    from_cache = Rails.cache.exist?(cache_key)

    data = Rails.cache.fetch(cache_key, expires_in: CACHE_EXPIRY) do
      api_response = fetch_weather_data
      format_response(api_response)
    end

    data.merge(from_cache: from_cache)
  end

  private

  def fetch_weather_data
    response = HTTParty.get(BASE_URL, query: build_query)
    raise StandardError, "Failed to fetch forecast: #{response.code}" unless response.success?
    response
  end

  def build_query
    query = { units: DEFAULT_UNITS, appid: @api_key }
    query[:lat] = @lat if @lat
    query[:lon] = @lon if @lon
    if @zip_code && @country_code
      query[:zip] = "#{@zip_code},#{@country_code}"
    end
    query
  end

  def format_response(response)
    {
      temperature: response["main"]["temp"],
      temp_min: response["main"]["temp_min"],
      temp_max: response["main"]["temp_max"],
      place: response["name"],
      weather: response["weather"].first["description"],
      fetched_at: Time.at(response["dt"]).in_time_zone(TIMEZONE)
    }
  end
end