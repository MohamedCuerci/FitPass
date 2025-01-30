class Gym < ApplicationRecord
  has_many :gym_hours, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_one :address, dependent: :destroy

  accepts_nested_attributes_for :address, :contacts

  has_many_attached :photos, dependent: :destroy

  enum :plan, {
        basic: 0,
        premium: 1,
        business: 2
      }

  validates :name, presence: true
  validates :plan, presence: true
end
