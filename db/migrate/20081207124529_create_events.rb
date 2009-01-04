class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string      :name,  :null => false
      t.text        :description
      t.integer     :price_cents, :default => 0, :null => false
      t.timestamps
    end
    add_index( :events, :name, :unique => true )
  end

  def self.down
    drop_table :events
  end
end
