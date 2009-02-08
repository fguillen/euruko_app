class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string        :name,                  :null => false
      t.string        :permalink,             :null => false
      t.string        :login,                 :null => false
      t.string        :email,                 :null => false
      t.string        :crypted_password,                        :limit => 40
      t.string        :salt,                                    :limit => 40
      t.string        :remember_token
      t.datetime      :remember_token_expires_at
      t.string        :activation_code,                         :limit => 40
      t.datetime      :activated_at
      
      t.string        :role,                  :null => false
      t.text          :text
      t.string        :personal_web_name
      t.string        :personal_web_url
      t.string        :company_name
      t.string        :company_url
      t.boolean       :public_profile,        :null => false
      t.text          :invoice_info

      t.timestamps
    end
    add_index :users, :login,     :unique => true
    add_index :users, :email,     :unique => true
    add_index :users, :permalink, :unique => true
    
  end

  def self.down
    drop_table :users
  end
end

