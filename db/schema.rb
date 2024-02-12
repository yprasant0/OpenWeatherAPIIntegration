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

ActiveRecord::Schema[7.0].define(version: 2024_02_09_165638) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "air_qualities", force: :cascade do |t|
    t.bigint "monitoring_location_id", null: false
    t.integer "aqi"
    t.float "pm2_5"
    t.float "pm10"
    t.float "co"
    t.float "so2"
    t.float "no2"
    t.float "o3"
    t.datetime "measured_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["monitoring_location_id"], name: "index_air_qualities_on_monitoring_location_id"
  end

  create_table "monitoring_locations", force: :cascade do |t|
    t.string "name"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "air_qualities", "monitoring_locations"
end
