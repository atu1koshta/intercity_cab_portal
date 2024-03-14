class CreateBooking < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :customer, foreign_key: { to_table: :users }, null: false
      t.references :start_city, foreign_key: { to_table: :cities }, null: false
      t.references :assigned_cab, foreign_key: { to_table: :cabs }, null: false
      t.datetime :booking_time, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime :trip_start_at, null: false
      t.datetime :trip_end_at, null: false

      t.timestamps
    end

    add_index :bookings, :assigned_cab
  end
end
