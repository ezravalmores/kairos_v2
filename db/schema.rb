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

ActiveRecord::Schema.define(version: 20140210151335) do

  create_table "departments", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organization_roles", force: true do |t|
    t.integer "organization_id"
    t.string  "name"
    t.string  "description"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "username"
    t.string   "password"
    t.boolean  "is_active",                                         default: true
    t.integer  "role_id"
    t.integer  "department_id"
    t.time     "start_time"
    t.time     "end_time"
    t.boolean  "can_approve"
    t.decimal  "remaining_vacation_leave", precision: 10, scale: 0
    t.decimal  "remaining_sick_leave",     precision: 10, scale: 0
    t.integer  "organization_id"
    t.string   "time_zone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_role_id"
  end

  create_table "person_tasks", force: true do |t|
    t.integer  "person_id"
    t.integer  "task_id"
    t.time     "start_time"
    t.time     "end_time"
    t.time     "total_time"
    t.boolean  "is_submitted",     default: false
    t.boolean  "is_approved",      default: false
    t.integer  "role_id"
    t.integer  "updated_by"
    t.integer  "approved_by"
    t.boolean  "is_overtime"
    t.integer  "specific_task_id"
    t.string   "shift_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "person_in_charge"
    t.text     "note"
    t.datetime "start"
    t.datetime "end"
  end

  create_table "role_specific_tasks", force: true do |t|
    t.integer "organization_id"
    t.integer "department_id"
    t.integer "role_task_id"
    t.integer "specific_task_id"
    t.string  "name"
  end

  create_table "role_tasks", force: true do |t|
    t.integer "organization_id"
    t.integer "department_id"
    t.integer "task_id"
    t.string  "name"
    t.integer "organization_role_id"
    t.boolean "is_active",            default: true
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "specific_tasks", force: true do |t|
    t.string  "name"
    t.integer "department_id"
    t.integer "task_id"
    t.string  "description"
    t.boolean "is_active",     default: true
  end

  create_table "tasks", force: true do |t|
    t.string  "name"
    t.integer "department_id"
    t.string  "description"
    t.boolean "is_active",     default: true
  end

end
