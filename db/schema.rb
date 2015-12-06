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

ActiveRecord::Schema.define(version: 20151206194456) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bootcamps", force: true do |t|
    t.string   "name"
    t.string   "location"
    t.date     "starts_at"
    t.date     "ends_at"
    t.integer  "level"
    t.integer  "community_price"
    t.integer  "normal_price"
    t.integer  "supporter_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "published_at"
  end

  create_table "discount_codes", force: true do |t|
    t.string   "code"
    t.integer  "discount_percentage"
    t.string   "slug"
    t.datetime "valid_until"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clicks"
    t.integer  "student_id"
  end

  add_index "discount_codes", ["slug"], name: "index_discount_codes_on_slug", using: :btree
  add_index "discount_codes", ["student_id"], name: "index_discount_codes_on_student_id", using: :btree

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
    t.datetime "paid_at"
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
    t.text     "qr_code"
    t.boolean  "terms_and_conditions"
    t.boolean  "manually_paid"
    t.boolean  "paid_by_creditcard"
    t.integer  "discount_code_id"
    t.text     "invoice_url"
    t.boolean  "paid_by_ideal",         default: false
    t.integer  "invoice_id"
    t.integer  "bootcamp_id"
  end

  add_index "orders", ["bootcamp_id"], name: "index_orders_on_bootcamp_id", using: :btree
  add_index "orders", ["discount_code_id"], name: "index_orders_on_discount_code_id", using: :btree

  create_table "pages", force: true do |t|
    t.string   "title"
    t.string   "slug"
    t.text     "body"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "dutch_version"
  end

  add_index "pages", ["slug"], name: "index_pages_on_slug", unique: true, where: "(published = true)", using: :btree

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

  create_table "reviews", force: true do |t|
    t.integer  "student_id"
    t.string   "avatar"
    t.integer  "rating"
    t.integer  "bootcamp_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language"
    t.datetime "original_date"
  end

  add_index "reviews", ["bootcamp_id"], name: "index_reviews_on_bootcamp_id", using: :btree
  add_index "reviews", ["student_id"], name: "index_reviews_on_student_id", using: :btree

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
    t.string   "role"
    t.text     "bio"
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
    t.uuid     "identifier"
    t.boolean  "owns_laptop",     default: false
    t.text     "phone_number"
    t.string   "occupation"
  end

  add_index "students", ["identifier"], name: "index_students_on_identifier", using: :btree
  add_index "students", ["order_id"], name: "index_students_on_order_id", using: :btree

  create_table "user_profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "role"
    t.string   "twitter_handle"
    t.text     "linkedin_url"
    t.string   "github_handle"
    t.boolean  "core",           default: false
    t.boolean  "teacher",        default: false
    t.boolean  "coach",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_profiles", ["user_id"], name: "index_user_profiles_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin",                  default: false
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
