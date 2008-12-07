class CreateSpeakers < ActiveRecord::Migration
  def self.up
    create_table :speakers do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :speakers
  end
end
