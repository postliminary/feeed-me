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

ActiveRecord::Schema.define(version: 20141001021201) do

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "entries", force: true do |t|
    t.integer  "feed_id"
    t.string   "title"
    t.string   "url"
    t.string   "author"
    t.text     "content"
    t.text     "summary"
    t.datetime "published"
    t.datetime "updated"
    t.text     "categories"
    t.string   "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "summary_text"
  end

  add_index "entries", ["feed_id"], name: "index_entries_on_feed_id", using: :btree
  add_index "entries", ["published"], name: "index_entries_on_published", using: :btree
  add_index "entries", ["updated_at"], name: "index_entries_on_updated_at", using: :btree

  create_table "feeds", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "site_url"
  end

  add_index "feeds", ["title"], name: "index_feeds_on_title", using: :btree
  add_index "feeds", ["updated_at"], name: "index_feeds_on_updated_at", using: :btree

end
