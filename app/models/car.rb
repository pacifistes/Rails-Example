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
class Car < ApplicationRecord
  belongs_to :vehicle

  BRANDS = [ "TESLA", "MERCEDES" ].freeze() # freeze allow to block the list so it put the array as a constant
  TESLA_MODELS = %w[MODEL_S MODEL_3 MODEL_X MODEL_Y CYBERTRUCK ROADSTER].freeze
  MERCEDES_MODELS = %w[A_CLASS C_CLASS E_CLASS S_CLASS G_CLASS GLC GLE AMG_GT].freeze
  MODELS = (TESLA_MODELS + MERCEDES_MODELS).freeze()
  GEARBOXS = [ "MANUAL", "AUTOMATIC" ].freeze()
  FUEL_TYPES = [ "PETROL", "DIESEL", "ELECTRIC" ].freeze()

  validates :brand, presence: true, inclusion: { in: BRANDS, message: "%{value} is not a valid car brand" }
  validates :model, presence: true, inclusion: { in: MODELS, message: "%{value} is not a valid car model" }
  validates :gearbox, presence: true, inclusion: { in: GEARBOXS, message: "%{value} is not a valid car gearbox" }
  validates :fuel_type, presence: true, inclusion: { in: FUEL_TYPES, message: "%{value} is not a valid car fuel type" }
  validates :engine_cc, presence: true
  validates :seats, presence: true

  include Validators::CarValidator
end
