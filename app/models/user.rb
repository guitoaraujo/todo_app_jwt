class User < ApplicationRecord
  has_secure_password

  has_many :lists

  validates :username, :password, presence: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 6 }
end
