# == Schema Information
#
# Table name: cars
#
#  id         :integer          not null, primary key
#  brand      :string
#  engine_cc  :integer
#  fuel_type  :string
#  gearbox    :string
#  model      :string
#  seats      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  vehicle_id :integer          not null
#
# Indexes
#
#  index_cars_on_vehicle_id  (vehicle_id)
#
# Foreign Keys
#
#  vehicle_id  (vehicle_id => vehicles.id)
#
class Car < ApplicationRecord
  belongs_to :vehicle
end
