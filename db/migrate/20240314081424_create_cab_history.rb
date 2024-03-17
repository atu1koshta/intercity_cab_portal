class CreateCabHistory < ActiveRecord::Migration[7.0]
  def change
    create_table :cab_histories do |t|
      t.references :cab, foreign_key: { to_table: :cabs }, null: false, index: true
      t.references :booking_source, foreign_key: { to_table: :cities }
      t.integer :state, null: false, default: 0, index: true
      t.datetime :start_time, null: false
      t.datetime :end_time

      t.timestamps
    end
  end
end
