class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: { to_table: :users }
      t.date :from_date
      t.date :to_date
      t.string :status
      t.text :status_reason

      t.timestamps
    end
  end
end
