class AddLocationFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :location_country, :string
    add_column :users, :location_name, :string
  end

  def self.down
    remove_column :users, :location_name
    remove_column :users, :location_country
  end
end
