class Address < ApplicationRecord
  belongs_to :gym

  geocoded_by :full_address
  after_validation :geocode, if: :will_save_change_to_full_address?

  def full_address
    # Ajuste conforme seus campos
    [street, number, neighborhood, city, state].compact.join(', ')
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
end
