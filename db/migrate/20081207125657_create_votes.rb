class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer       :user_id,   :null => false
      t.integer       :paper_id,  :null => false
      t.integer       :points, :null => false
      t.timestamps
    end
    add_index( :votes, [:user_id, :paper_id], :unique => true, :name => 'idx_unique_user_id_paper_id_on_votes' )
  end

  def self.down
    drop_table :votes
  end
end
