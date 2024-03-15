# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  role            :integer          default("CLIENT"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryGirl.define do
  factory :user do
    username "MyString"
    password_digest "MyString"
  end
end
