# == Schema Information
#
# Table name: motorbikes
#
#  id          :integer          not null, primary key
#  brand       :string           not null
#  engine_cc   :integer          not null
#  has_sidecar :boolean          default(FALSE), not null
#  model       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  vehicle_id  :integer          not null
#
# Indexes
#
#  index_motorbikes_on_vehicle_id  (vehicle_id)
#
# Foreign Keys
#
#  vehicle_id  (vehicle_id => vehicles.id)
#
require "test_helper"

class MotorbikeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
