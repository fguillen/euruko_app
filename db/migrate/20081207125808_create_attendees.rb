class CreateAttendees < ActiveRecord::Migration
  def self.up
    create_table :attendees do |t|
      t.integer       :user_id,   :null => false
      t.integer       :paper_id,  :null => false
      t.timestamps
    end
    add_index( :attendees, [:user_id, :paper_id], :unique => true, :name => 'idx_unique_user_id_paper_id_on_attendees' )
  end

  def self.down
    drop_table :attendees
  end
end
