class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer     :user_id,     :null => false
      t.integer     :event_id,    :null => false
      t.timestamps
    end
    add_index( :payments, [:user_id, :event_id], :unique => true, :name => 'idx_unique_user_id_event_id_on_payments' )
  end
  
  def self.down
    drop_table :payments
  end
end
