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
require "test_helper"

class VehicleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
