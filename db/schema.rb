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

ActiveRecord::Schema.define(version: 20151121210130) do

  create_table "checkins", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "goal_id"
    t.integer  "checkin_result",                            default: 0
    t.decimal  "contribute_amount", precision: 6, scale: 2
    t.string   "checkin_type",                              default: "regular"
    t.string   "checkin_note"
    t.string   "contribution_id"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  add_index "checkins", ["goal_id", "user_id"], name: "index_checkins_on_goal_id_and_user_id"
  add_index "checkins", ["goal_id"], name: "index_checkins_on_goal_id"
  add_index "checkins", ["user_id"], name: "index_checkins_on_user_id"

  create_table "goals", force: :cascade do |t|
    t.string   "permalink"
    t.integer  "user_id"
    t.string   "goal_type"
    t.string   "short_description"
    t.text     "long_description"
    t.string   "reminder_frequency"
    t.decimal  "deserve_amount",     precision: 6, scale: 2
    t.string   "reward_type"
    t.string   "reward"
    t.string   "reward_link"
    t.decimal  "amount_needed"
    t.integer  "goal_status",                                default: 0
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  add_index "goals", ["user_id", "permalink", "goal_status"], name: "index_goals_on_user_id_and_permalink_and_goal_status"
  add_index "goals", ["user_id"], name: "index_goals_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "last_name"
    t.string   "email"
    t.string   "sms"
    t.string   "permalink"
    t.boolean  "activation_flag", default: false
    t.string   "activation_code"
    t.string   "password_digest"
    t.boolean  "admin",           default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["permalink"], name: "index_users_on_permalink"

end
