# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140406185703) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "inbetween_places", force: true do |t|
    t.integer  "place_before_id"
    t.integer  "place_after_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  add_index "inbetween_places", ["place_after_id"], name: "index_inbetween_places_on_place_after_id", using: :btree
  add_index "inbetween_places", ["place_before_id"], name: "index_inbetween_places_on_place_before_id", using: :btree

  create_table "library_items", force: true do |t|
    t.string   "name"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.string   "location_type"
    t.text     "description"
  end

  create_table "photos", force: true do |t|
    t.string   "image"
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trip_id"
  end

  create_table "places", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "lat"
    t.decimal  "lon"
    t.integer  "following_users_count", default: 0
    t.string   "name"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "special_emails", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trip_places", force: true do |t|
    t.integer  "trip_id"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort"
  end

  add_index "trip_places", ["place_id"], name: "index_trip_places_on_place_id", using: :btree
  add_index "trip_places", ["trip_id"], name: "index_trip_places_on_trip_id", using: :btree

  create_table "trips", force: true do |t|
    t.string   "name"
    t.string   "source"
    t.string   "destination"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "transport"
    t.date     "trip_date"
    t.boolean  "draft_version", default: false
    t.string   "slug"
    t.integer  "no_of_shares",  default: 0,     null: false
    t.integer  "no_of_likes",   default: 0,     null: false
  end

  add_index "trips", ["slug"], name: "index_trips_on_slug", using: :btree

  create_table "user_followed_places", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "place_id"
  end

  add_index "user_followed_places", ["user_id"], name: "index_user_followed_places_on_user_id", using: :btree

  create_table "user_invites", force: true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "sign_up_token"
    t.string   "sign_up_source"
    t.boolean  "signed_up"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_invites", ["user_id"], name: "index_user_invites_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                   default: "", null: false
    t.string   "encrypted_password",      default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "username"
    t.string   "fb_authentication_token"
    t.string   "slug"
    t.integer  "failed_attempts",         default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.integer  "following_places_count",  default: 0
    t.integer  "no_of_likes",             default: 0,  null: false
    t.string   "avatar"
    t.integer  "age"
    t.string   "gender"
    t.string   "full_name"
    t.string   "current_loc"
    t.text     "desc"
    t.string   "twitter_uid"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email", "username"], name: "email_username_uniqueness", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "users_liked_trips", force: true do |t|
    t.integer  "user_id"
    t.integer  "trip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_liked_trips", ["trip_id"], name: "index_users_liked_trips_on_trip_id", using: :btree
  add_index "users_liked_trips", ["user_id"], name: "index_users_liked_trips_on_user_id", using: :btree

end
