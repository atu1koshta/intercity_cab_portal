# == Schema Information
#
# Table name: cabs
#
#  id                   :integer          not null, primary key
#  city_id              :integer
#  state                :integer          default("IDLE"), not null
#  last_idle_start_time :datetime
#  total_idle_time      :bigint           default(0), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
FactoryGirl.define do
  factory :cab do
    
  end
end
