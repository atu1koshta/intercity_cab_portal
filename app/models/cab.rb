class Cab < ApplicationRecord
  enum state: { IDLE: 0, ON_TRIP: 1 }

  validates :city_id, presence: true
  validates_associated :city
  validates :state, presence: true

  belongs_to :city
end
