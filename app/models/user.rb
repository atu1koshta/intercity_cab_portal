class User < ApplicationRecord
  has_secure_password

  enum role: { CLIENT: 0, ADMIN: 1 }

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :role, presence: true
end
