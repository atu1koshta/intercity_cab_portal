# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_03_14_081920) do
  create_table "bookings", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "start_city_id", null: false
    t.integer "assigned_cab_id", null: false
    t.datetime "booking_time", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "trip_start_at", null: false
    t.datetime "trip_end_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "\"assigned_cab\"", name: "index_bookings_on_assigned_cab"
    t.index ["assigned_cab_id"], name: "index_bookings_on_assigned_cab_id"
    t.index ["customer_id"], name: "index_bookings_on_customer_id"
    t.index ["start_city_id"], name: "index_bookings_on_start_city_id"
  end

  create_table "cab_histories", force: :cascade do |t|
    t.integer "cab_id"
    t.integer "state", default: 0, null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cab_id"], name: "index_cab_histories_on_cab_id"
    t.index ["state"], name: "index_cab_histories_on_state"
  end

  create_table "cabs", force: :cascade do |t|
    t.integer "city_id", null: false
    t.integer "state", default: 0, null: false
    t.datetime "last_idle_start_time"
    t.bigint "total_idle_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_cabs_on_city_id"
    t.index ["state"], name: "index_cabs_on_state"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "bookings", "cabs", column: "assigned_cab_id"
  add_foreign_key "bookings", "cities", column: "start_city_id"
  add_foreign_key "bookings", "users", column: "customer_id"
  add_foreign_key "cab_histories", "cabs"
  add_foreign_key "cabs", "cities"
end
