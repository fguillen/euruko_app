class CreateCarts < ActiveRecord::Migration
  def self.up
    create_table :carts do |t|
      t.integer       :user_id,       :null => false
      t.text          :paypal_params
      t.string        :transaction_id
      t.datetime      :purchased_at
      t.string        :status
      t.text          :invoice_info
      t.timestamps
    end
  end
  
  def self.down
    drop_table :carts
  end
end
