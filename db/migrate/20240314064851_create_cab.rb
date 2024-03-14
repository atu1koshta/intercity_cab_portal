class CreateCab < ActiveRecord::Migration[7.0]
  def change
    create_table :cabs do |t|
      t.references :city, foreign_key: { to_table: :cities }, null: false
      t.integer :state, null: false, default: 0
      t.datetime :last_idle_start_time
      t.bigint :total_idle_time
      t.timestamps
    end
    add_index :cabs, :state
  end
end
