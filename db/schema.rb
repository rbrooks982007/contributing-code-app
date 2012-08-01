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

ActiveRecord::Schema.define(:version => 20120801213548) do

  create_table "add_requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.string   "team_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "join_requests", :force => true do |t|
    t.string   "user_handle"
    t.integer  "team_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "team_members", :force => true do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.string   "user_handle"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.string   "owner_handle"
    t.integer  "member_count"
    t.string   "desc"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "image"
    t.string   "repo"
    t.string   "site"
    t.boolean  "checkin",      :default => false
    t.integer  "rank"
    t.text     "app_desc"
    t.string   "tech"
    t.string   "snapshot"
    t.string   "title"
  end

  create_table "users", :force => true do |t|
    t.integer  "uid"
    t.string   "name"
    t.string   "email"
    t.string   "handle"
    t.string   "avatar"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "tee"
    t.string   "gender"
    t.integer  "transport"
  end

  create_table "winners", :force => true do |t|
    t.string   "pic"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "image"
  end

end
