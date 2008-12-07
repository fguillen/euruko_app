class CreateReporters < ActiveRecord::Migration
  def self.up
    create_table :reporters do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :reporters
  end
end
