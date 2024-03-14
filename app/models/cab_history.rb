class CabHistory < ApplicationRecord
  enum state: { IDLE: 0, ON_TRIP: 1 }

  validates :cab_id, presence: true
  validates_associated :cab

  belongs_to :cab
end
