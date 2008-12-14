class CreatePapers < ActiveRecord::Migration
  def self.up
    create_table :papers do |t|
      t.string      :title, :null => false, :limit => 255
      t.text        :description
      t.string      :type,    :null => false
      t.string      :status,  :null => false
      t.datetime    :date
      t.integer     :minutes, :default => -1, :null => false
      t.integer     :room_id
      t.timestamps
    end
  end

  def self.down
    drop_table :papers
  end
end
