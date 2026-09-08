# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_07_175754) do
  create_table "operations", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "position", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "work_order_id", null: false
    t.index ["work_order_id"], name: "index_operations_on_work_order_id"
  end

  create_table "parts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "inventory_quantity", default: 0, null: false
    t.string "name", null: false
    t.string "number", null: false
    t.string "revision"
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_parts_on_number", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "work_orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "due_on", null: false
    t.text "notes"
    t.string "number", null: false
    t.integer "part_id", null: false
    t.integer "quantity", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_work_orders_on_number", unique: true
    t.index ["part_id"], name: "index_work_orders_on_part_id"
  end

  add_foreign_key "operations", "work_orders"
  add_foreign_key "sessions", "users"
  add_foreign_key "work_orders", "parts"
end
