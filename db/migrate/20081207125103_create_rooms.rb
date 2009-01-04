class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.string      :name, :null => false, :limit => 255
      t.text        :notes
      t.timestamps
    end
    add_index( :rooms, :name, :unique => true )
  end

  def self.down
    drop_table :rooms
  end
end
