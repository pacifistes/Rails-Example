# == Schema Information
#
# Table name: vehicles
#
#  id                 :integer          not null, primary key
#  description        :text
#  price_by_day       :decimal(10, 2)
#  vehicle_type       :string
#  year_of_production :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  added_by_id        :integer          not null
#
# Indexes
#
#  index_vehicles_on_added_by_id  (added_by_id)
#
# Foreign Keys
#
#  added_by_id  (added_by_id => users.id)
#
class Vehicle < ApplicationRecord
  belongs_to :added_by, class_name: "User"
  has_many_attached :images

  VEHICULE_TYPES = [ "CAR", "MOTOR_BIKE" ].freeze() # freeze allow to block the list so it put the array as a constant

  validates :vehicle_type, inclusion: { in: VEHICULE_TYPES, message: "%{value} is not a valid vehicle" }
end
