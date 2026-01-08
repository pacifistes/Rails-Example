class CreateVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicles do |t|
      t.string :vehicle_type
      t.text :description
      t.decimal :price_by_day, precision: 10, scale: 2
      t.integer :year_of_production
      t.references :added_by, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
