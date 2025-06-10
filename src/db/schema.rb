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

ActiveRecord::Schema[8.0].define(version: 4) do
  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "name_id", null: false
    t.text "bio", default: "", null: false
    t.string "login_password", null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "anyur_id"
    t.index ["anyur_id"], name: "index_accounts_on_anyur_id", unique: true
    t.index ["login_password"], name: "index_accounts_on_login_password", unique: true
    t.index ["name_id"], name: "index_accounts_on_name_id", unique: true
  end

  create_table "posts", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.text "content", default: "", null: false
    t.text "cache", size: :long, default: "{}", null: false, collation: "utf8mb4_bin"
    t.bigint "account_id", null: false
    t.bigint "post_id"
    t.string "name_id", null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_posts_on_account_id"
    t.index ["name_id"], name: "index_posts_on_name_id", unique: true
    t.index ["post_id"], name: "index_posts_on_post_id"
    t.check_constraint "json_valid(`cache`)", name: "cache"
  end

  create_table "reactions", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.integer "kind", limit: 1, default: 0, null: false
    t.bigint "account_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "post_id"], name: "index_reactions_on_account_id_and_post_id", unique: true
    t.index ["account_id"], name: "index_reactions_on_account_id"
    t.index ["post_id"], name: "index_reactions_on_post_id"
  end

  add_foreign_key "posts", "accounts"
  add_foreign_key "posts", "posts"
  add_foreign_key "reactions", "accounts"
  add_foreign_key "reactions", "posts"
end
