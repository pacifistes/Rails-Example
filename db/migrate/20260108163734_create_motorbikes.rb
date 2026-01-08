class CreateMotorbikes < ActiveRecord::Migration[8.1]
  def change
    create_table :motorbikes do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.string :brand
      t.string :model
      t.integer :engine_cc
      t.boolean :has_sidecar

      t.timestamps
    end
  end
end
