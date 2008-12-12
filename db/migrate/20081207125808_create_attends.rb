class CreateAttends < ActiveRecord::Migration
  def self.up
    create_table :attends do |t|
      t.integer       :user_id,   :null => false
      t.integer       :paper_id,  :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :attends
  end
end
