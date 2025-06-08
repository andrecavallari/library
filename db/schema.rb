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

ActiveRecord::Schema[8.0].define(version: 2025_06_07_235400) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "books", force: :cascade do |t|
    t.integer "copies", default: 0, null: false
    t.string "title", null: false
    t.string "author", null: false
    t.string "genre", null: false
    t.string "isbn", null: false
    t.tsvector "tsv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "active_borrows_count", default: 0, null: false
    t.index ["isbn"], name: "index_books_on_isbn", unique: true
    t.index ["tsv"], name: "index_books_on_tsv", using: :gin
  end

  create_table "borrows", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "book_id", null: false
    t.date "return_at", default: -> { "(now() + 'P14D'::interval)" }, null: false
    t.datetime "returned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_borrows_on_book_id"
    t.index ["return_at"], name: "index_borrows_on_return_at", using: :brin
    t.index ["user_id", "book_id"], name: "index_borrows_on_user_and_book", unique: true
    t.index ["user_id"], name: "index_borrows_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "borrows", "books"
  add_foreign_key "borrows", "users"
end
