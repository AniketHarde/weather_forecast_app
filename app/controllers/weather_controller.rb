class WeatherController < ApplicationController
  def index
    flash.clear
  end

  def show
    zip = params[:zip_code]
    country = params[:country_code]

    service = WeatherService.new(zip_code: zip, country_code: country)

    begin
      @forecast = service.get_forecast
    rescue StandardError => e
      flash[:alert] = "Failed to fetch forecast: #{e.message}"
      render :index
    end
  end
end
