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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130225010235) do

  create_table "events", :force => true do |t|
    t.string   "name"
    t.date     "date"
    t.string   "hashtag"
    t.integer  "creator_id"
    t.integer  "trip_id"
    t.string   "tagline"
    t.binary   "picture"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "events", ["hashtag"], :name => "index_events_on_hashtag"

  create_table "trip_administratorings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "trip_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "trip_administratorings", ["trip_id"], :name => "index_trip_administratorings_on_trip_id"
  add_index "trip_administratorings", ["user_id", "trip_id"], :name => "index_trip_administratorings_on_user_id_and_trip_id", :unique => true
  add_index "trip_administratorings", ["user_id"], :name => "index_trip_administratorings_on_user_id"

  create_table "trip_whitelistings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "trip_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "trip_whitelistings", ["trip_id"], :name => "index_trip_whitelistings_on_trip_id"
  add_index "trip_whitelistings", ["user_id", "trip_id"], :name => "index_trip_whitelistings_on_user_id_and_trip_id", :unique => true
  add_index "trip_whitelistings", ["user_id"], :name => "index_trip_whitelistings_on_user_id"

  create_table "trips", :force => true do |t|
    t.integer  "creator_id"
    t.string   "name"
    t.string   "tagline"
    t.text     "description"
    t.string   "hashtag"
    t.date     "s_date"
    t.date     "e_date"
    t.boolean  "public_view",       :default => true
    t.boolean  "whitelist_posters", :default => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "trips", ["hashtag"], :name => "index_trips_on_hashtag"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "tagline"
    t.string   "password_digest"
    t.integer  "profile_id"
    t.string   "session_token",                      :null => false
    t.boolean  "site_admin",      :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["session_token"], :name => "index_users_on_session_token", :unique => true

end
