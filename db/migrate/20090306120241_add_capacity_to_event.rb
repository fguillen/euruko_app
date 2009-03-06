class AddCapacityToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :capacity, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :events, :capacity
  end
end
