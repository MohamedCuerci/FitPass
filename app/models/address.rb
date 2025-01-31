class Address < ApplicationRecord
  belongs_to :gym

  geocoded_by :full_address
  after_validation :geocode, if: :should_geocode?

  def full_address
    # Ajuste conforme seus campos
    [street, number, neighborhood, city, state].compact.join(', ')
  end

  def part_address
    [street, number].compact.join(", ")
  end

  before_save :set_latitude_and_longitude

  def set_latitude_and_longitude
    results = Geocoder.search(find_address)
    coordinates = results.first.coordinates
    latitude = coordinates.first
    longitude = coordinates.last

    # self.update!(latitude: latitude, longitude: longitude)
    self.latitude = latitude
    self.longitude = longitude
  end

  def find_country
    results = Geocoder.search([street, neighborhood, city, state].compact.join(", "))
    results.first.country
  end

  def find_address
    [street, city, state, find_country].compact.join(', ')
  end

  private

  # Método para determinar se a geocodificação deve ser executada
  def should_geocode?
    will_save_change_to_street? || will_save_change_to_number? || will_save_change_to_neighborhood? || will_save_change_to_city? || will_save_change_to_state?
  end
end
