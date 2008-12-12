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

ActiveRecord::Schema.define(:version => 20081212174835) do

  create_table "attends", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "paper_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "paper_id",   :null => false
    t.integer  "user_id",    :null => false
    t.text     "text",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "configurations", :force => true do |t|
    t.string   "name",       :limit => 20, :null => false
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name",                       :null => false
    t.text     "description"
    t.integer  "price_cents", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "paper_status", :force => true do |t|
    t.string   "name",        :limit => 20, :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "paper_types", :force => true do |t|
    t.string   "name",        :limit => 20, :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "papers", :force => true do |t|
    t.string   "title",           :null => false
    t.text     "description"
    t.integer  "paper_type_id",   :null => false
    t.integer  "paper_status_id", :null => false
    t.datetime "date"
    t.integer  "minutes",         :null => false
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "event_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",        :limit => 20, :null => false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms", :force => true do |t|
    t.string   "name",       :null => false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "speakers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "paper_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                                                                         :null => false
    t.string   "login",                                                                        :null => false
    t.string   "email",                                                                        :null => false
    t.string   "crypted_password",                                               :limit => 40
    t.string   "salt",                                                           :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",                                                :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "activated_at"
    t.datetime "#<ActiveRecord::ConnectionAdapters::TableDefinition:0x1e27024>"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "paper_id",   :null => false
    t.integer  "points",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
