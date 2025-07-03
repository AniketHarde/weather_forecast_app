class AddressLookupService
  def initialize(address)
    @address = address
  end

  def lookup
    results = Geocoder.search(@address)

    return nil if results.empty?
    best_match = find_best_indian_result(results) || results.first

    # Retry with coordinates if postal_code is missing
    best_match = retry_with_coordinates_if_needed(best_match)

    best_match
  end

  private

  def find_best_indian_result(results)
    indian_results = results.select { |r| r.data.dig("address", "country") == "India" }
    indian_results.max_by { |r| similarity_score(r.address) }
  end

  def similarity_score(result_address)
    (@address.downcase.split & result_address.downcase.split).size
  end

  def retry_with_coordinates_if_needed(match)
    return match unless match&.postal_code.nil? && match&.coordinates.present?

    coord_results = Geocoder.search(match.coordinates)
    coord_best = find_best_indian_result(coord_results)
    coord_best&.postal_code.present? ? coord_best : match
  end
end