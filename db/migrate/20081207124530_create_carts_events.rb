class CreateCartsEvents < ActiveRecord::Migration
  def self.up
    create_table :carts_events do |t|
      t.integer     :cart_id
      t.integer     :event_id
      t.timestamps
    end
    add_index( :carts_events, [:cart_id, :event_id], :unique => true, :name => 'idx_unique_cart_id_event_id_on_carts' )
  end

  def self.down
    drop_table :carts_events
  end
end