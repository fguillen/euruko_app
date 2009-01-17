class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string      :name,        :null => false
      t.string      :permalink,   :null => false
      t.text        :description
      t.integer     :price_cents, :default => 0, :null => false
      t.timestamps
    end
    add_index( :events, :name,      :unique => true, :name => 'idx_events_name' )
    add_index( :events, :permalink, :unique => true, :name => 'idx_events_permalink_unique' )

  end

  def self.down
    drop_table :events
  end
end
