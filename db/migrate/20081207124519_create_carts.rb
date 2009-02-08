class CreateCarts < ActiveRecord::Migration
  def self.up
    create_table :carts do |t|
      t.integer       :user_id,       :null => false
      t.text          :paypal_notify_params
      t.text          :paypal_complete_params
      t.string        :paypal_status
      t.string        :transaction_id
      t.datetime      :purchased_at
      t.string        :status,        :null => false
      t.text          :invoice_info
      t.text          :paypal_errors
      t.timestamps
    end
  end
  
  def self.down
    drop_table :carts
  end
end
