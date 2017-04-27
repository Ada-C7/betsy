
ActiveRecord::Schema.define(version: 20170426173201) do


  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_categories_on_name", using: :btree
  end

  create_table "categories_products", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "product_id"
    t.index ["category_id"], name: "index_categories_products_on_category_id", using: :btree
    t.index ["product_id"], name: "index_categories_products_on_product_id", using: :btree
  end

  create_table "merchants", force: :cascade do |t|
    t.string   "merchant_name"
    t.string   "merchant_email"
    t.string   "username"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "oauth_uid"
    t.string   "oauth_provider"
  end

  create_table "orderproducts", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "status"
    t.index ["order_id"], name: "index_orderproducts_on_order_id", using: :btree
    t.index ["product_id"], name: "index_orderproducts_on_product_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.string   "status"
    t.string   "cc_num"
    t.string   "cc_name"
    t.string   "order_email"
    t.string   "mailing_address"
    t.string   "cc_expiry"
    t.integer  "buyer_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "cvv"
  end

  create_table "products", force: :cascade do |t|
<<<<<<< HEAD
    t.string  "product_name"
    t.float   "price"
    t.integer "merchant_id"
    t.string  "photo_url",           default: "http://www.rawdogplus.com/wp-content/uploads/2015/05/pic-coming-soon_150x150.jpg"
    t.integer "stock"
    t.string  "product_description"
    t.string  "category"
=======
    t.string   "product_name"
    t.float    "price"
    t.integer  "merchant_id"
    t.string   "photo_url"
    t.integer  "stock"
    t.string   "product_description"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "original_stock"
>>>>>>> 5cc8ad0e13a6653c9a5939fe5ad6be207c048421
    t.index ["merchant_id"], name: "index_products_on_merchant_id", using: :btree
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "rating"
    t.string   "review_description"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "nickname",           default: "Anonymous Customer"
    t.index ["product_id"], name: "index_reviews_on_product_id", using: :btree
  end

end
