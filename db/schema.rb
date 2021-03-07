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

ActiveRecord::Schema.define(version: 2021_02_27_102055) do

  create_table "assignments", charset: "utf8", force: :cascade do |t|
    t.bigint "reviewer_id", null: false
    t.bigint "reviewee_id", null: false
    t.bigint "creator_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_assignments_on_creator_id"
    t.index ["id", "reviewer_id", "reviewee_id"], name: "index_assignments_on_id_and_reviewer_id_and_reviewee_id", unique: true
    t.index ["reviewee_id"], name: "index_assignments_on_reviewee_id"
    t.index ["reviewer_id"], name: "index_assignments_on_reviewer_id"
  end

  create_table "employees", charset: "utf8", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "gender", default: 0, null: false
    t.string "department", null: false
    t.string "phone_number", null: false
    t.text "address", null: false
    t.boolean "is_admin", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["department"], name: "index_employees_on_department"
    t.index ["email"], name: "index_employees_on_email"
    t.index ["full_name"], name: "index_employees_on_full_name"
  end

  create_table "questions", charset: "utf8", force: :cascade do |t|
    t.text "description", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.timestamp "deleted_at"
  end

  create_table "reviews", charset: "utf8", force: :cascade do |t|
    t.bigint "assignment_id", null: false
    t.bigint "question_id", null: false
    t.text "answer", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["assignment_id", "question_id"], name: "index_reviews_on_assignment_id_and_question_id", unique: true
    t.index ["assignment_id"], name: "index_reviews_on_assignment_id"
    t.index ["question_id"], name: "index_reviews_on_question_id"
  end

  add_foreign_key "assignments", "employees", column: "creator_id"
  add_foreign_key "assignments", "employees", column: "reviewee_id"
  add_foreign_key "assignments", "employees", column: "reviewer_id"
  add_foreign_key "reviews", "assignments"
  add_foreign_key "reviews", "questions"
end
