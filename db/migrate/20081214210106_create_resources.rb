class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.integer   :paper_id, :null => false
      t.string    :url,       :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
