class CreateCars < ActiveRecord::Migration[8.1]
  def change
    create_table :cars do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.string :brand
      t.string :model
      t.integer :seats
      t.string :fuel_type
      t.string :gearbox
      t.integer :engine_cc

      t.timestamps
    end
  end
end
