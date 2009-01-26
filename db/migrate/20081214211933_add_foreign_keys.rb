# I am using for this the plugin: redhillonrails_core
# http://www.redhillonrails.org/redhillonrails_core.html
class AddForeignKeys < ActiveRecord::Migration
  def self.up
    # events
    add_foreign_key( :carts, :user_id, :users, :id, :name => :fk_cart_user )
    
    # carts_events
    add_foreign_key( :carts_events, :cart_id, :carts, :id, :name => :fk_carts_events_cart )
    add_foreign_key( :carts_events, :event_id, :events, :id, :name => :fk_carts_events_event )

        
    # papers
    add_foreign_key( :papers, :room_id, :rooms, :id, :name => :fk_paper_room )
    add_foreign_key( :papers, :creator_id, :users, :id, :name => :fk_paper_creator )
    
    # resources
    add_foreign_key( :resources, :paper_id, :papers, :id, :name => :fk_resource_paper )
    add_foreign_key( :resources, :user_id, :users, :id, :name => :fk_resource_user )

    # attendees
    add_foreign_key( :attendees, :paper_id, :papers, :id, :name => :fk_attendee_paper )
    add_foreign_key( :attendees, :user_id, :users, :id, :name => :fk_attendee_user )
    
    # speakers
    add_foreign_key( :speakers, :paper_id, :papers, :id, :name => :fk_speaker_paper )
    add_foreign_key( :speakers, :user_id, :users, :id, :name => :fk_speaker_user )
    
    # votes
    add_foreign_key( :votes, :paper_id, :papers, :id, :name => :fk_vote_paper )
    add_foreign_key( :votes, :user_id, :users, :id, :name => :fk_vote_user )
    
    # comments
    add_foreign_key( :comments, :paper_id, :papers, :id, :name => :fk_comment_paper )
    add_foreign_key( :comments, :user_id, :users, :id, :name => :fk_comment_user )
    
  end

  def self.down
    remove_foreign_key( :carts, :fk_cart_user )
    
    remove_foreign_key( :carts_events, :fk_carts_events_cart )
    remove_foreign_key( :carts_events, :fk_carts_events_event )

    remove_foreign_key( :papers, :fk_paper_room )
    remove_foreign_key( :papers, :fk_paper_creator )
    
    remove_foreign_key( :resources, :fk_resource_paper )
    remove_foreign_key( :resources, :fk_resource_user )
    
    remove_foreign_key( :attendees, :fk_attendee_paper )
    remove_foreign_key( :attendees, :fk_attendee_user )
    
    remove_foreign_key( :speakers, :fk_speaker_paper )
    remove_foreign_key( :speakers, :fk_speaker_user )
    
    remove_foreign_key( :votes, :fk_vote_paper )
    remove_foreign_key( :votes, :fk_vote_user )
    
    remove_foreign_key( :comments, :fk_comment_paper )
    remove_foreign_key( :comments, :fk_comment_user )
  end
end
