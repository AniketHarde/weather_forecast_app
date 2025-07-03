class WeatherController < ApplicationController
  def index
    @history = session[:history] || []
  end

  def clear_history
    session[:history] = []
    respond_to do |format|
      format.json { render json: { success: true } }
    end
  end

  def clear_cache
    Rails.cache.clear
    respond_to do |format|
      format.json { render json: { success: true } }
    end
  end

  def show
    address = params[:address]
    update_history(address)

    location = AddressLookupService.new(address).lookup

    if location.nil?
      flash[:alert] = "Address not found. Please try again by entering full address with a postal code."
      redirect_to root_path and return
    end

    begin
      @forecast = fetch_forecast(location)
    rescue => e
      flash[:alert] = e.message
      redirect_to root_path and return
    end
  end

  private

  def update_history(address)
    session[:history] ||= []
    session[:history].unshift(address)
    session[:history] = session[:history].uniq.first(5)
  end

  def fetch_forecast(location)
    WeatherService.new(
      lat: location.latitude,
      lon: location.longitude,
      zip_code: location.postal_code,
      country_code: location.country_code,
      address: location.address
    ).get_forecast
  end
end