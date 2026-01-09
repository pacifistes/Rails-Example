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
class Motorbike < ApplicationRecord
  belongs_to :vehicle

  BRANDS = [ "HONDA", "YAMAHA", "KAWASAKI", "DUCATI", "BMW", "HARLEY_DAVIDSON" ].freeze() # freeze allow to block the list so it put the array as a constant
  MODELS = [ "SPORTBIKE", "CRUISER" ].freeze()

  validates :brand, presence: true, inclusion: { in: BRANDS, message: "%{value} is not a valid motor bike brand" }
  validates :model, presence: true, inclusion: { in: MODELS, message: "%{value} is not a valid motor bike model" }
  validates :engine_cc, presence: true
end
