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

ActiveRecord::Schema.define(version: 2024_11_12_185607) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilities", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.date "date"
    t.decimal "available_hours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employee_id", "date"], name: "index_availabilities_on_employee_id_and_date", unique: true
    t.index ["employee_id"], name: "index_availabilities_on_employee_id"
  end

  create_table "employee_skills", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employee_id", "skill_id"], name: "index_employee_skills_on_employee_id_and_skill_id", unique: true
    t.index ["employee_id"], name: "index_employee_skills_on_employee_id"
    t.index ["skill_id"], name: "index_employee_skills_on_skill_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.decimal "daily_hours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_skills_on_name", unique: true
  end

  create_table "task_assignments", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "employee_id", null: false
    t.date "assigned_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employee_id"], name: "index_task_assignments_on_employee_id"
    t.index ["task_id", "assigned_date"], name: "index_task_assignments_on_task_id_and_assigned_date", unique: true
    t.index ["task_id"], name: "index_task_assignments_on_task_id"
  end

  create_table "task_skills", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["skill_id"], name: "index_task_skills_on_skill_id"
    t.index ["task_id", "skill_id"], name: "index_task_skills_on_task_id_and_skill_id", unique: true
    t.index ["task_id"], name: "index_task_skills_on_task_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.date "due_date"
    t.decimal "estimated_hours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "availabilities", "employees"
  add_foreign_key "employee_skills", "employees"
  add_foreign_key "employee_skills", "skills"
  add_foreign_key "task_assignments", "employees"
  add_foreign_key "task_assignments", "tasks"
  add_foreign_key "task_skills", "skills"
  add_foreign_key "task_skills", "tasks"
end
