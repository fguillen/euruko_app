class CreatePapers < ActiveRecord::Migration
  def self.up
    create_table :papers do |t|
      t.string      :title,       :null => false, :limit => 255
      t.string      :permalink,   :nul  => false
      t.text        :description
      t.string      :family,      :null => false
      t.string      :status,      :null => false
      t.datetime    :date
      t.integer     :minutes,     :default => 0, :null => false
      t.integer     :room_id
      t.integer     :creator_id,  :null => true
      t.timestamps
    end
    
    add_index :papers, :permalink, :name => 'idx_papers_permalink', :unique => true
  end

  def self.down
    drop_table :papers
  end
end
