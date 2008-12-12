class PaperStatus < ActiveRecord::Migration
  def self.up
    create_table :paper_status do |t|
      t.string      :name, :null => false, :limit => 20
      t.text        :description
      t.timestamps
    end
  end

  def self.down
    drop_table :paper_status
  end
end
