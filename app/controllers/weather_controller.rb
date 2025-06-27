class WeatherController < ApplicationController
  def index
  end

  def show
    zip = params[:zip_code]
    country = params[:country_code]

    service = WeatherService.new(zip_code: zip, country_code: country)

    begin
      @forecast = service.get_forecast
    rescue => e
      @error = e.message
    end
  end
end
