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

ActiveRecord::Schema.define(version: 20150122223401) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "orders", force: true do |t|
    t.decimal  "price"
    t.datetime "payed_at"
    t.string   "mollie_payment_id"
    t.string   "refunded_at"
    t.string   "mollie_refund_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "billing_company_name"
    t.string   "billing_name"
    t.string   "billing_email"
    t.string   "billing_address"
    t.string   "billing_postal"
    t.string   "billing_city"
    t.string   "billing_phone"
    t.string   "billing_vat_id"
    t.string   "billing_country"
    t.json     "cart"
    t.datetime "confirmed_at"
    t.string   "mollie_status"
    t.string   "mollie_payment_method"
    t.uuid     "identifier"
    t.string   "stripe_token"
    t.json     "stripe_payload"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.text     "cover_image"
    t.integer  "user_id"
    t.datetime "published_at"
    t.datetime "unpublished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["slug"], name: "index_posts_on_slug", unique: true, using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "speakers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "twitter_handle"
    t.string   "website"
    t.text     "remarks"
    t.text     "description"
    t.datetime "activated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsors", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.string   "website"
    t.string   "logo"
    t.boolean  "hiring"
    t.string   "email"
    t.text     "remarks"
    t.datetime "activated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "plan"
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "students", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "twitter_handle"
    t.date     "birth_date"
    t.string   "preferred_level"
    t.string   "github_handle"
    t.text     "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "allergies"
    t.integer  "registration"
    t.integer  "order_id"
  end

  add_index "students", ["order_id"], name: "index_students_on_order_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
