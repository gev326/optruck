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

ActiveRecord::Schema.define(version: 20180412042641) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "drivers", force: :cascade do |t|
    t.string   "first_name",          null: false
    t.string   "last_name"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "current_city"
    t.string   "desired_city"
    t.string   "desired_state"
    t.string   "desired_zip"
    t.string   "driver_id_tag"
    t.string   "driver_phone"
    t.string   "driver_truck_type"
    t.boolean  "active"
    t.string   "driver_status"
    t.date     "driver_availability"
    t.string   "driver_company"
    t.string   "comments"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "user_id"
    t.boolean  "PlateTrailer"
    t.boolean  "Etrac"
    t.string   "PreferredLanes"
    t.boolean  "backhaul"
    t.boolean  "Covered"
    t.string   "current_state"
    t.string   "insurance"
    t.string   "destination_zone"
    t.string   "contact_name"
    t.string   "current_zone"
    t.string   "last_updated_by"
    t.index ["user_id"], name: "index_drivers_on_user_id", using: :btree
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "driver_ids",                default: [],              array: true
    t.string   "full_name_cont"
    t.string   "driver_id_tag_eq"
    t.string   "current_state_eq"
    t.string   "current_city_cont"
    t.integer  "miles"
    t.string   "driver_company_cont"
    t.string   "driver_phone_cont"
    t.string   "driver_truck_type_eq"
    t.boolean  "active_eq"
    t.boolean  "PlateTrailer_eq"
    t.boolean  "Etrac_eq"
    t.boolean  "backhaul_eq"
    t.string   "driver_availability_in"
    t.string   "PreferredLanes_cont_any"
    t.string   "destination_zone_cont_any"
    t.string   "current_zone_cont_any"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_reports_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",           null: false
    t.string   "encrypted_password",     default: "",           null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,            null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "account_type",           default: "dispatcher", null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "views", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_views_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_views_on_reset_password_token", unique: true, using: :btree
  end

end
