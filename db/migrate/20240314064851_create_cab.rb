class CreateCab < ActiveRecord::Migration[7.0]
  def change
    create_table :cabs do |t|
      t.references :city, foreign_key: { to_table: :cities }, index: true
      t.integer :state, null: false, default: 0, index: true
      t.datetime :last_idle_start_time
      t.bigint :total_idle_time, null: false, default: 0
      t.timestamps
    end
  end
end
