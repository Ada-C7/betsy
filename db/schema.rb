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

ActiveRecord::Schema.define(version: 20170428211345) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_products", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "product_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_categories_products_on_category_id", using: :btree
    t.index ["product_id"], name: "index_categories_products_on_product_id", using: :btree
  end

  create_table "merchants", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "email"
    t.string   "username"
    t.text     "description"
    t.string   "name"
    t.integer  "uid",         null: false
    t.string   "provider",    null: false
  end

  create_table "orderitems", force: :cascade do |t|
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order_id"
    t.integer  "product_id"
    t.index ["order_id"], name: "index_orderitems_on_order_id", using: :btree
    t.index ["product_id"], name: "index_orderitems_on_product_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "email"
    t.string   "address"
    t.string   "cc_name"
    t.integer  "cc_num"
    t.string   "cc_expiry"
    t.integer  "cc_security"
    t.integer  "zip"
    t.string   "status",      default: "pending"
  end

  create_table "products", force: :cascade do |t|
    t.string  "name"
    t.float   "price"
    t.integer "quantity"
    t.integer "merchant_id"
    t.text    "description"
    t.string  "image_url",   default: "http://img13.deviantart.net/1568/i/2015/280/7/b/donut_ghost_by_doctorhue2-d9cbpmk.png"
    t.boolean "status",      default: true
  end

  create_table "reviews", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "rating"
    t.integer  "product_id"
    t.text     "description"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "orderitems", "orders"
  add_foreign_key "orderitems", "products"
end
