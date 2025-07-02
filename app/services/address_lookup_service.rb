class AddressLookupService
  def initialize(address)
    @address = address
  end

  def lookup
    results = Geocoder.search(@address)
    results.first
  end
end