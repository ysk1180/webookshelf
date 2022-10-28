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

ActiveRecord::Schema.define(version: 2022_10_28_102417) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "asin"
    t.string "title"
    t.string "image"
    t.string "url"
    t.integer "page"
    t.string "released_at"
    t.index ["asin"], name: "index_books_on_asin", unique: true
  end

  create_table "bookshelf_books", force: :cascade do |t|
    t.integer "book_id"
    t.integer "bookshelf_id"
  end

  create_table "bookshelves", force: :cascade do |t|
    t.string "title"
    t.string "user_name"
    t.string "h"
    t.string "twitter_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title1"
    t.string "image1"
    t.string "url1"
    t.string "title2"
    t.string "image2"
    t.string "url2"
    t.string "title3"
    t.string "image3"
    t.string "url3"
    t.string "title4"
    t.string "image4"
    t.string "url4"
    t.string "title5"
    t.string "image5"
    t.string "url5"
    t.string "title"
    t.string "name"
    t.string "h"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "twitter_id"
    t.boolean "migrated", default: false
  end

end
