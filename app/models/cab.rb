class Cab < ApplicationRecord
  enum state: { IDLE: 0, ON_TRIP: 1 }

  before_validation :set_last_idle_start_time_if_idle

  validates :city_id, presence: true
  validates_associated :city
  validates :state, presence: true
  validates :total_idle_time, presence: true

  belongs_to :city

  private

  def set_last_idle_start_time_if_idle
    self.last_idle_start_time = Time.current if state == 'IDLE'
  end
end
