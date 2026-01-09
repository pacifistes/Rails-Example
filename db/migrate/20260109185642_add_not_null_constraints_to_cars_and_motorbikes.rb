class AddNotNullConstraintsToCarsAndMotorbikes < ActiveRecord::Migration[8.1]
  def change
    # Add NOT NULL constraints to cars table
    change_column_null :cars, :brand, false
    change_column_null :cars, :model, false
    change_column_null :cars, :fuel_type, false
    change_column_null :cars, :gearbox, false
    change_column_null :cars, :engine_cc, false
    change_column_null :cars, :seats, false

    # Add NOT NULL constraints to motorbikes table
    change_column_null :motorbikes, :brand, false
    change_column_null :motorbikes, :model, false
    change_column_null :motorbikes, :engine_cc, false
    change_column_default :motorbikes, :has_sidecar, false
    change_column_null :motorbikes, :has_sidecar, false
  end
end
