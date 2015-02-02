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

ActiveRecord::Schema.define(version: 20150201180940) do

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guests", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invitation_id"
  end

  add_index "guests", ["email_address"], name: "index_guests_on_email_address", unique: true
  add_index "guests", ["invitation_id"], name: "index_guests_on_invitation_id"

  create_table "invitation_groups", force: true do |t|
    t.string   "code"
    t.integer  "max_guests"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitation_groups", ["code"], name: "index_invitation_groups_on_code", unique: true

  create_table "invitations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "invitation_group_id"
  end

  add_index "invitations", ["event_id"], name: "index_invitations_on_event_id"
  add_index "invitations", ["invitation_group_id"], name: "index_invitations_on_invitation_group_id"

end
