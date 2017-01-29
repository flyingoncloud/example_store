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

ActiveRecord::Schema.define(version: 20170121073203) do

  create_table "answers", force: :cascade do |t|
    t.text     "answer_text"
    t.integer  "problem_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "image_ids"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "knowledge_points", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id",   default: 0
    t.string   "parent_name"
    t.integer  "level"
    t.text     "memo"
    t.string   "is_leaf",     default: "N"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "cart_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "quantity",   default: 1
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
    t.index ["product_id"], name: "index_line_items_on_product_id"
  end

  create_table "problem_knowledge_points", force: :cascade do |t|
    t.integer  "problem_id"
    t.string   "knowledge_point_ids"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "problem_tags", force: :cascade do |t|
    t.integer  "problem_id"
    t.string   "knowledge_point_id"
    t.string   "tag_ids"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "problems", force: :cascade do |t|
    t.text     "problem_text"
    t.string   "image_ids"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image_url"
    t.decimal  "price",       precision: 8
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.text     "alias"
    t.integer  "parent_id",   default: 0
    t.string   "parent_name", default: ""
    t.integer  "level",       default: 0
    t.text     "memo",        default: ""
    t.string   "is_leaf",     default: "N"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
