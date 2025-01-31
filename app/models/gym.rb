class Gym < ApplicationRecord
  has_many :gym_hours, dependent: :destroy
  has_one :address, dependent: :destroy
  delegate :latitude, :longitude, to: :address # permite acessar diretamente gym.latitude | dym.longitude

  accepts_nested_attributes_for :address

  has_many_attached :photos, dependent: :destroy

  # preciso entender essas duas linhas
  # geocoded_by :address
  # after_validation :geocode, if: :will_save_change_to_address?

  include PgSearch::Model
  pg_search_scope :search_by_name_and_location,
    against: :name,
    associated_against: {
      address: [:street, :neighborhood, :city]
    },
    using: {
      tsearch: { prefix: true }
    }

  enum :plan, {
        basic: 0,
        premium: 1,
        business: 2
      }

  validates :name, presence: true
  validates :plan, presence: true

  def distance_from(localization)
    return nil unless localization

    distance = Geocoder::Calculations.distance_between([localization.first, localization.last], [latitude, longitude])
    # "#{(distance * 1.8).round(2).to_s.gsub('.', ',')} km"
    (distance * 1.8).round(2)
  end
end
