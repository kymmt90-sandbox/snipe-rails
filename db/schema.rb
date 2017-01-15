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

ActiveRecord::Schema.define(version: 20170115082802) do

  create_table "comments", force: :cascade do |t|
    t.string   "content",           null: false
    t.integer  "comment_author_id"
    t.integer  "snippet_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["comment_author_id"], name: "index_comments_on_comment_author_id"
    t.index ["snippet_id"], name: "index_comments_on_snippet_id"
  end

  create_table "snippets", force: :cascade do |t|
    t.string   "title"
    t.text     "content",    null: false
    t.integer  "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_snippets_on_author_id"
  end

  create_table "stars", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "snippet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["snippet_id"], name: "index_stars_on_snippet_id"
    t.index ["user_id"], name: "index_stars_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end