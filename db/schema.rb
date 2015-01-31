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

ActiveRecord::Schema.define(version: 20150131211107) do

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events_invitations", id: false, force: true do |t|
    t.integer "event_id",      null: false
    t.integer "invitation_id", null: false
  end

  add_index "events_invitations", ["invitation_id", "event_id"], name: "index_events_invitations_on_invitation_id_and_event_id", unique: true

  create_table "invitations", force: true do |t|
    t.string   "code"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["code"], name: "index_invitations_on_code", unique: true

end
