class CreateCabHistory < ActiveRecord::Migration[7.0]
  def change
    create_table :cab_histories do |t|
      t.references :cab, foreign_key: { to_table: :cabs }
      t.integer :state, null: false, default: 0
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false

      t.timestamps
    end

    add_index :cab_histories, :state
  end
end
