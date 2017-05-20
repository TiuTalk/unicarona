# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170520194438) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "rails_push_notifications_apns_apps", id: :serial, force: :cascade do |t|
    t.text "apns_dev_cert"
    t.text "apns_prod_cert"
    t.boolean "sandbox_mode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rails_push_notifications_gcm_apps", id: :serial, force: :cascade do |t|
    t.string "gcm_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rails_push_notifications_mpns_apps", id: :serial, force: :cascade do |t|
    t.text "cert"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rails_push_notifications_notifications", id: :serial, force: :cascade do |t|
    t.text "destinations"
    t.integer "app_id"
    t.string "app_type"
    t.text "data"
    t.text "results"
    t.integer "success"
    t.integer "failed"
    t.boolean "sent", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id", "app_type", "sent"], name: "app_and_sent_index_on_rails_push_notifications"
  end

  create_table "rides", force: :cascade do |t|
    t.bigint "driver_id"
    t.bigint "passenger_id"
    t.bigint "route_id"
    t.boolean "driver_liked", default: false
    t.boolean "passenger_liked", default: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_rides_on_driver_id"
    t.index ["passenger_id"], name: "index_rides_on_passenger_id"
    t.index ["route_id"], name: "index_rides_on_route_id"
  end

  create_table "routes", force: :cascade do |t|
    t.bigint "user_id"
    t.string "origin"
    t.string "destination"
    t.string "weekdays"
    t.time "hour"
    t.boolean "enabled", default: true
    t.decimal "origin_latitude", precision: 9, scale: 6
    t.decimal "origin_longitude", precision: 9, scale: 6
    t.decimal "destination_latitude", precision: 9, scale: 6
    t.decimal "destination_longitude", precision: 9, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_routes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone"
    t.string "phone_confirmation_code"
    t.boolean "phone_confirmed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", limit: 128
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128
    t.text "device_token"
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  add_foreign_key "rides", "routes"
  add_foreign_key "rides", "users", column: "driver_id"
  add_foreign_key "rides", "users", column: "passenger_id"
end
