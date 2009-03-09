class RemovePermalinkIndexes < ActiveRecord::Migration
  def self.up
    remove_index( :users, :permalink )
    remove_index( :papers, :name => 'idx_papers_permalink' )
    remove_index( :rooms, :permalink )
    remove_index( :events, :name => 'idx_events_permalink_unique' )    
  end

  def self.down
    add_index( :events, :permalink, :unique => true, :name => 'idx_events_permalink_unique' )
    add_index( :rooms, :permalink,  :unique => true )
    add_index( :users, :permalink, :unique => true )
    add_index( :papers, :permalink, :name => 'idx_papers_permalink', :unique => true )
  end
end
