class AddNotNullConstraintsToVehicles < ActiveRecord::Migration[8.1]
  def change
    change_column_null :vehicles, :vehicle_type, false
    change_column_null :vehicles, :price_by_day, false
    change_column_null :vehicles, :year_of_production, false
  end
end
