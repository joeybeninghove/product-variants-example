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

ActiveRecord::Schema.define(version: 2018_02_02_154750) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "option_types", force: :cascade do |t|
    t.bigint "product_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_option_types_on_product_id"
  end

  create_table "option_value_variants", force: :cascade do |t|
    t.bigint "option_value_id"
    t.bigint "variant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_value_id"], name: "index_option_value_variants_on_option_value_id"
    t.index ["variant_id"], name: "index_option_value_variants_on_variant_id"
  end

  create_table "option_values", force: :cascade do |t|
    t.bigint "option_type_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_type_id"], name: "index_option_values_on_option_type_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "variants", force: :cascade do |t|
    t.string "sku"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.boolean "is_master"
    t.bigint "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_variants_on_product_id"
  end

  add_foreign_key "option_types", "products"
  add_foreign_key "option_value_variants", "option_values"
  add_foreign_key "option_value_variants", "variants"
  add_foreign_key "option_values", "option_types"
  add_foreign_key "variants", "products"
end
