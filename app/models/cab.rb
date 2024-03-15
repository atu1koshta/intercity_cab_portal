class Cab < ApplicationRecord
  enum state: { IDLE: 0, ON_TRIP: 1 }

  before_save :update_idle_time_and_reset_last_idle_start_time

  validates :total_idle_time, presence: true
  validate :city_id_presence_when_idle

  belongs_to :city, optional: true
  has_many :cab_histories, dependent: :destroy

  # Class methods

  def self.available_cab(city_id)
    idle_cabs_in_city = Cab.where(city_id:, state: 'IDLE')

    return if idle_cabs_in_city.empty?

    now = Time.current
    most_idle_cab = nil
    max_idle_time = 0

    idle_cabs_in_city.each do |cab|
      total_idle_time = cab.total_idle_time + (now - cab.last_idle_start_time)

      if total_idle_time > max_idle_time
        max_idle_time = total_idle_time
        most_idle_cab = cab
      end
    end

    most_idle_cab
  end

  private

  def update_idle_time_and_reset_last_idle_start_time
    now = Time.current
    idle_time = last_idle_start_time.present? ? now - last_idle_start_time : 0
    self.total_idle_time += idle_time
    self.last_idle_start_time = state == 'IDLE' ? now : nil
  end

  def city_id_presence_when_idle
    if state == 'IDLE' && city_id.nil?
      errors.add(:city_id, "can't be blank when state is IDLE")
    elsif state == 'ON_TRIP' && city_id.present?
      errors.add(:city_id, 'must be blank when state is ON_TRIP')
    end
  end
end
