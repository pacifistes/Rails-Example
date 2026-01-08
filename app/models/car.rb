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

  BRANDS = [ "TESLA", "MERCEDES" ].freeze() # freeze allow to block the list so it put the array as a constant
  MODELS = [ "MODEL_S", "MODEL_3", "MODEL_X", "MODEL_Y", "ROADSTER" ].freeze()
  GEARBOXS = [ "MANUAL", "AUTOMATIC" ].freeze()
  FUEL_TYPES = [ "PETROL", "DIESEL", "ELECTRIC" ].freeze()

  validates :brand, inclusion: { in: BRANDS, message: "%{value} is not a valid motor bike brand" }
  validates :model, inclusion: { in: MODELS, message: "%{value} is not a valid motor bike model" }
  validates :gearbox, inclusion: { in: GEARBOXS, message: "%{value} is not a valid motor bike gearbox" }
  validates :fuel_type, inclusion: { in: FUEL_TYPES, message: "%{value} is not a valid motor bike fuel type" }
end
