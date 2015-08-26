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

ActiveRecord::Schema.define(version: 20150824160959) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "events", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
  end

  create_table "guests", force: :cascade do |t|
    t.string   "first_name",          limit: 255
    t.string   "last_name",           limit: 255
    t.string   "email_address",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invitation_group_id"
  end

  add_index "guests", ["email_address"], name: "index_guests_on_email_address", unique: true
  add_index "guests", ["invitation_group_id"], name: "index_guests_on_invitation_group_id"

  create_table "invitation_groups", force: :cascade do |t|
    t.string   "code",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_confirmed",             default: false, null: false
  end

  add_index "invitation_groups", ["code"], name: "index_invitation_groups_on_code", unique: true

  create_table "invitations", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invitation_group_id"
    t.boolean  "is_accepted"
    t.integer  "event_id"
    t.integer  "guest_id"
  end

  add_index "invitations", ["event_id"], name: "index_invitations_on_event_id"
  add_index "invitations", ["guest_id"], name: "index_invitations_on_guest_id"
  add_index "invitations", ["invitation_group_id"], name: "index_invitations_on_invitation_group_id"

  create_table "reminder_emails", force: :cascade do |t|
    t.string  "body"
    t.string  "addresses"
    t.integer "invitation_group_id"
    t.date    "sent_date"
  end

  add_index "reminder_emails", ["invitation_group_id"], name: "index_reminder_emails_on_invitation_group_id"

end
