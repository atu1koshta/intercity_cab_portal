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
require "test_helper"

class CabHistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
