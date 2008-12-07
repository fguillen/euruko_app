class CreateTries < ActiveRecord::Migration
  def self.up
    create_table :tries do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :tries
  end
end
