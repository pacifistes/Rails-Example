# == Schema Information
#
# Table name: motorbikes
#
#  id          :integer          not null, primary key
#  brand       :string
#  engine_cc   :integer
#  has_sidecar :boolean
#  model       :string
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
class Motorbike < ApplicationRecord
  belongs_to :vehicle
end
