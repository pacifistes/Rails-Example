# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email_address   :string           not null
#  password_digest :string           not null
#  role            :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  enum :role, { customer: 0, admin: 1, motor_bike_manager: 2, car_manager: 3 }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :role, presence: true
  validates :email_address, presence: true, uniqueness: true
end
