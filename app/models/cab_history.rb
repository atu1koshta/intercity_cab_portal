class CabHistory < ApplicationRecord
  enum state: { IDLE: 0, ON_TRIP: 1 }

  validates :cab_id, presence: true
  validates_associated :cab

  belongs_to :cab
  belongs_to :booking_source, class_name: 'City', optional: true
end
