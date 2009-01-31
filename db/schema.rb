# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090123211524) do

  create_table "attendees", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "paper_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attendees", ["user_id", "paper_id"], :name => "idx_unique_user_id_paper_id_on_attendees", :unique => true

  create_table "carts", :force => true do |t|
    t.integer  "user_id",        :null => false
    t.text     "paypal_params"
    t.string   "transaction_id"
    t.datetime "purchased_at"
    t.string   "status",         :null => false
    t.text     "invoice_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carts_events", :force => true do |t|
    t.integer  "cart_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "carts_events", ["cart_id", "event_id"], :name => "idx_unique_cart_id_event_id_on_carts", :unique => true

  create_table "comments", :force => true do |t|
    t.integer  "paper_id",   :null => false
    t.integer  "user_id",    :null => false
    t.text     "text",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name",                       :null => false
    t.string   "permalink",                  :null => false
    t.text     "description"
    t.integer  "price_cents", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["permalink"], :name => "idx_events_permalink_unique", :unique => true
  add_index "events", ["name"], :name => "idx_events_name", :unique => true

  create_table "logged_exceptions", :force => true do |t|
    t.string   "exception_class"
    t.string   "controller_name"
    t.string   "action_name"
    t.text     "message"
    t.text     "backtrace"
    t.text     "environment"
    t.text     "request"
    t.datetime "created_at"
  end

  create_table "papers", :force => true do |t|
    t.string   "title",                      :null => false
    t.string   "permalink"
    t.text     "description"
    t.string   "family",                     :null => false
    t.string   "status",                     :null => false
    t.datetime "date"
    t.integer  "minutes",     :default => 0, :null => false
    t.integer  "room_id"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "papers", ["permalink"], :name => "idx_papers_permalink", :unique => true

  create_table "resources", :force => true do |t|
    t.integer  "paper_id",                      :null => false
    t.integer  "user_id",                       :null => false
    t.string   "url",                           :null => false
    t.boolean  "is_local",   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "permalink"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rooms", ["permalink"], :name => "index_rooms_on_permalink", :unique => true
  add_index "rooms", ["name"], :name => "index_rooms_on_name", :unique => true

  create_table "speakers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "paper_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "speakers", ["user_id", "paper_id"], :name => "idx_unique_user_id_paper_id_on_speakers", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name",                                    :null => false
    t.string   "permalink",                               :null => false
    t.string   "login",                                   :null => false
    t.string   "email",                                   :null => false
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "role",                                    :null => false
    t.text     "text"
    t.string   "personal_web_name"
    t.string   "personal_web_url"
    t.string   "company_name"
    t.string   "company_url"
    t.boolean  "public_profile",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_reset_code",       :limit => 40
  end

  add_index "users", ["permalink"], :name => "index_users_on_permalink", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "paper_id",   :null => false
    t.integer  "points",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["user_id", "paper_id"], :name => "idx_unique_user_id_paper_id_on_votes", :unique => true

end
