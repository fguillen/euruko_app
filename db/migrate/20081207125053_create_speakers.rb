class CreateSpeakers < ActiveRecord::Migration
  def self.up
    create_table :speakers do |t|
      t.integer     :user_id
      t.integer     :paper_id
      t.timestamps
    end
  end

  def self.down
    drop_table :speakers
  end
end
