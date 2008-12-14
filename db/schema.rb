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

ActiveRecord::Schema.define(:version => 20081214211933) do

  create_table "attends", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "paper_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attends", ["paper_id"], :name => "fk_attend_paper"
  add_index "attends", ["user_id"], :name => "fk_attend_user"

  create_table "comments", :force => true do |t|
    t.integer  "paper_id",   :null => false
    t.integer  "user_id",    :null => false
    t.text     "text",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["paper_id"], :name => "fk_comment_paper"
  add_index "comments", ["user_id"], :name => "fk_comment_user"

  create_table "events", :force => true do |t|
    t.string   "name",                       :null => false
    t.text     "description"
    t.integer  "price_cents", :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "papers", :force => true do |t|
    t.string   "title",                       :null => false
    t.text     "description"
    t.string   "type",                        :null => false
    t.string   "status",                      :null => false
    t.datetime "date"
    t.integer  "minutes",     :default => -1, :null => false
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "papers", ["room_id"], :name => "fk_paper_room"

  create_table "payments", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "event_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["user_id"], :name => "fk_payment_user"
  add_index "payments", ["event_id"], :name => "fk_payment_event"

  create_table "resources", :force => true do |t|
    t.integer  "paper_id",   :null => false
    t.string   "url",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resources", ["paper_id"], :name => "fk_resource_paper"

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

  add_index "speakers", ["paper_id"], :name => "fk_speaker_paper"
  add_index "speakers", ["user_id"], :name => "fk_speaker_user"

  create_table "users", :force => true do |t|
    t.string   "name",                                    :null => false
    t.string   "login",                                   :null => false
    t.string   "email",                                   :null => false
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "role",                                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "paper_id",   :null => false
    t.integer  "points",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["paper_id"], :name => "fk_vote_paper"
  add_index "votes", ["user_id"], :name => "fk_vote_user"

  add_foreign_key "attends", ["user_id"], "users", ["id"], :on_delete => :cascade, :name => "fk_attend_user"
  add_foreign_key "attends", ["paper_id"], "papers", ["id"], :on_delete => :cascade, :name => "fk_attend_paper"

  add_foreign_key "comments", ["user_id"], "users", ["id"], :on_delete => :cascade, :name => "fk_comment_user"
  add_foreign_key "comments", ["paper_id"], "papers", ["id"], :on_delete => :cascade, :name => "fk_comment_paper"

  add_foreign_key "papers", ["room_id"], "rooms", ["id"], :name => "fk_paper_room"

  add_foreign_key "payments", ["event_id"], "events", ["id"], :name => "fk_payment_event"
  add_foreign_key "payments", ["user_id"], "users", ["id"], :name => "fk_payment_user"

  add_foreign_key "resources", ["paper_id"], "papers", ["id"], :on_delete => :cascade, :name => "fk_resource_paper"

  add_foreign_key "speakers", ["user_id"], "users", ["id"], :on_delete => :cascade, :name => "fk_speaker_user"
  add_foreign_key "speakers", ["paper_id"], "papers", ["id"], :on_delete => :cascade, :name => "fk_speaker_paper"

  add_foreign_key "votes", ["user_id"], "users", ["id"], :on_delete => :cascade, :name => "fk_vote_user"
  add_foreign_key "votes", ["paper_id"], "papers", ["id"], :on_delete => :cascade, :name => "fk_vote_paper"

end
