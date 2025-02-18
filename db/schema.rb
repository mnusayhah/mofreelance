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

ActiveRecord::Schema[7.1].define(version: 2025_02_13_172607) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "discussions", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "freelancer_id", null: false
    t.bigint "enterprise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enterprise_id"], name: "index_discussions_on_enterprise_id"
    t.index ["freelancer_id"], name: "index_discussions_on_freelancer_id"
    t.index ["project_id"], name: "index_discussions_on_project_id"
  end

  create_table "educations", force: :cascade do |t|
    t.string "school"
    t.string "diploma"
    t.date "start_date"
    t.date "end_date"
    t.string "localisation"
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_educations_on_profile_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "discussion_id", null: false
    t.bigint "sender_id", null: false
    t.bigint "receiver_id", null: false
    t.text "content"
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discussion_id"], name: "index_messages_on_discussion_id"
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.string "address"
    t.text "bio"
    t.integer "years_of_experience"
    t.string "skills"
    t.string "portfolio_url"
    t.decimal "hourly_rate"
    t.string "availability_status"
    t.string "language"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.text "description"
    t.decimal "budget"
    t.string "status"
    t.string "required_skills"
    t.string "visibility"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "rated_user_id", null: false
    t.bigint "project_id", null: false
    t.integer "score"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_reviews_on_project_id"
    t.index ["rated_user_id"], name: "index_reviews_on_rated_user_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "shared_projects", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "freelancer_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["freelancer_id"], name: "index_shared_projects_on_freelancer_id"
    t.index ["project_id"], name: "index_shared_projects_on_project_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "job_title"
    t.string "company"
    t.date "start_date"
    t.date "end_date"
    t.text "description"
    t.string "localisation"
    t.bigint "profile_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_skills_on_profile_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "role"
    t.string "company"
    t.string "phone_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "discussions", "projects"
  add_foreign_key "discussions", "users", column: "enterprise_id"
  add_foreign_key "discussions", "users", column: "freelancer_id"
  add_foreign_key "educations", "profiles"
  add_foreign_key "messages", "discussions"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "profiles", "users"
  add_foreign_key "projects", "users"
  add_foreign_key "reviews", "projects"
  add_foreign_key "reviews", "users"
  add_foreign_key "reviews", "users", column: "rated_user_id"
  add_foreign_key "shared_projects", "projects"
  add_foreign_key "shared_projects", "users", column: "freelancer_id"
  add_foreign_key "skills", "profiles"
end
