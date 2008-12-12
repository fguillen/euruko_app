class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string        :name,                  :null => false
      t.string        :login,                 :null => false
      t.string        :email,                 :null => false
      t.string        :crypted_password,                        :limit => 40
      t.string        :salt,                                    :limit => 40
      t.string        :remember_token
      t.datetime      :remember_token_expires_at
      t.string        :activation_code,                         :limit => 40
      t.datetime      :activated_at,

      t.timestamps
    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table :users
  end
end

