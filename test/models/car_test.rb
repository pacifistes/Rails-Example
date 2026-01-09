# == Schema Information
#
# Table name: cars
#
#  id         :integer          not null, primary key
#  brand      :string           not null
#  engine_cc  :integer          not null
#  fuel_type  :string           not null
#  gearbox    :string           not null
#  model      :string           not null
#  seats      :integer          not null
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
require "test_helper"

class CarTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
