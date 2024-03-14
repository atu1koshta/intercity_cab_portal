class Cab < ApplicationRecord
  enum state: { IDLE: 0, ON_TRIP: 1 }

  before_validation :set_last_idle_start_time_if_idle

  validates :total_idle_time, presence: true
  validate :city_id_presence_when_idle

  belongs_to :city, optional: true

  private

  def set_last_idle_start_time_if_idle
    self.last_idle_start_time = Time.current if state == 'IDLE'
  end

  def city_id_presence_when_idle
    if state == 'IDLE' && city_id.nil?
      errors.add(:city_id, "can't be blank when state is IDLE")
    elsif state == 'ON_TRIP' && city_id.present?
      errors.add(:city_id, 'must be blank when state is ON_TRIP')
    end
  end
end
