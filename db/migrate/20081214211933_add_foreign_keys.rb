# I am using for this the plugin: redhillonrails_core
# http://www.redhillonrails.org/redhillonrails_core.html
class AddForeignKeys < ActiveRecord::Migration
  def self.up
    # events
    add_foreign_key( :payments, :user_id, :users, :id, :name => :fk_payment_user )
    add_foreign_key( :payments, :event_id, :events, :id, :name => :fk_payment_event )
    
    # papers
    add_foreign_key( :papers, :room_id, :rooms, :id, :name => :fk_paper_room )
    
    # resources
    add_foreign_key( :resources, :paper_id, :papers, :id, :on_delete => :cascade, :name => :fk_resource_paper )
    
    # attends
    add_foreign_key( :attends, :paper_id, :papers, :id, :on_delete => :cascade, :name => :fk_attend_paper )
    add_foreign_key( :attends, :user_id, :users, :id, :on_delete => :cascade, :name => :fk_attend_user )
    
    # speakers
    add_foreign_key( :speakers, :paper_id, :papers, :id, :on_delete => :cascade, :name => :fk_speaker_paper )
    add_foreign_key( :speakers, :user_id, :users, :id, :on_delete => :cascade, :name => :fk_speaker_user )
    
    # votes
    add_foreign_key( :votes, :paper_id, :papers, :id, :on_delete => :cascade, :name => :fk_vote_paper )
    add_foreign_key( :votes, :user_id, :users, :id, :on_delete => :cascade, :name => :fk_vote_user )
    
    # comments
    add_foreign_key( :comments, :paper_id, :papers, :id, :on_delete => :cascade, :name => :fk_comment_paper )
    add_foreign_key( :comments, :user_id, :users, :id, :on_delete => :cascade, :name => :fk_comment_user )
    
  end

  def self.down
    remove_foreign_key( :payments, :fk_payment_event )
    remove_foreign_key( :payments, :fk_payment_user )

    remove_foreign_key( :papers, :fk_paper_room )
    
    remove_foreign_key( :resources, :fk_resource_paper )
    
    remove_foreign_key( :attends, :fk_attend_paper )
    remove_foreign_key( :attends, :fk_attend_user )
    
    remove_foreign_key( :speakers, :fk_speaker_paper )
    remove_foreign_key( :speakers, :fk_speaker_user )
    
    remove_foreign_key( :votes, :fk_vote_paper )
    remove_foreign_key( :votes, :fk_vote_user )
    
    remove_foreign_key( :comments, :fk_comment_paper )
    remove_foreign_key( :comments, :fk_comment_user )
  end
end
