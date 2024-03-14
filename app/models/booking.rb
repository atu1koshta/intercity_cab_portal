class Booking < ApplicationRecord
  belongs_to :customer, class_name: 'User'
  belongs_to :start_city, class_name: 'City'
  belongs_to :assigned_cab, class_name: 'Cab'

  validates :customer_id, presence: true
  validates_associated :customer

  validates :start_city_id, presence: true
  validates_associated :start_city

  validates :assigned_cab_id, presence: true
  validates_associated :assigned_cab

  validates :booking_time, presence: true
  validates :trip_start_at, presence: true
  validates :trip_end_at, presence: true
end
