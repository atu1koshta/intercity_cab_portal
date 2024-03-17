# == Schema Information
#
# Table name: cab_histories
#
#  id                :integer          not null, primary key
#  cab_id            :integer          not null
#  booking_source_id :integer
#  state             :integer          default("IDLE"), not null
#  start_time        :datetime         not null
#  end_time          :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class CabHistory < ApplicationRecord
  enum state: { IDLE: 0, ON_TRIP: 1 }

  validates :cab_id, presence: true
  validates_associated :cab

  belongs_to :cab
  belongs_to :booking_source, class_name: 'City', optional: true

  before_create :set_start_time

  private

  def set_start_time
    self.start_time = Time.current
  end
end
