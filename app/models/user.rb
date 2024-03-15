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
class User < ApplicationRecord
  has_secure_password

  enum role: { CLIENT: 0, ADMIN: 1 }

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :role, presence: true
end
