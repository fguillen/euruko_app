class CreateStaticPages < ActiveRecord::Migration
  def self.up
    create_table :static_pages do |t|
      t.string  :title,     :null => false
      t.text    :content,   :null => false
      t.string  :permalink, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :static_pages
  end
end
