require File.dirname(__FILE__) + '/../test_helper'

class AttendeesControllerTest < ActionController::TestCase
  def setup

  end
  
  def test_on_create_with_logged_should_create_attendee
    @paper = papers(:paper2)
    @user = users(:user2)
    login_as @user
    
    assert( !@user.attendees.collect{|a| a.paper}.include?( @paper ) )
    
    assert_difference('Attendee.count', 1) do
      post(
        :create, 
        :paper_id => @paper.id
      )
    end
    
    @user.reload
    assert( @user.attendees.collect{|a| a.paper}.include?( @paper ) )    
    assert_not_nil( flash[:notice] )
    assert_redirected_to paper_path(@paper)
  end

  def test_on_create_with_not_logged_should_redirect_to_new_session
    assert_difference('Attendee.count', 0) do
      post(
        :create, 
        :paper_id => papers(:paper1).id
      )
    end
    
    assert_not_nil( flash[:error] )
    assert_redirected_to new_session_path
  end

  def test_on_destroy_with_logged_should_destroy_attendee
    @paper = papers(:paper1)
    @user = users(:user1)
    login_as @user
    
    assert( @user.attendees.collect{|a| a.paper}.include?( @paper ) )
    
    assert_difference('Attendee.count', -1) do
      delete(
        :destroy, 
        :paper_id => @paper.id,
        :id => attendees(:user1_go_paper1).id
      )
    end
    
    @user.reload
    assert( !@user.attendees.collect{|a| a.paper}.include?( @paper ) )    
    assert_not_nil( flash[:notice] )
    assert_redirected_to paper_path(@paper)
  end
  
  def test_on_destroy_with_logged_but_not_the_user_should_404
    @paper = papers(:paper1)
    @user = users(:user1)
    login_as users(:user2)
    
    assert( @user.attendees.collect{|a| a.paper}.include?( @paper ) )
    
    assert_difference('Attendee.count', 0) do
      delete(
        :destroy, 
        :paper_id => @paper.id,
        :id => attendees(:user1_go_paper1).id
      )
    end
    
    @user.reload
    assert( @user.attendees.collect{|a| a.paper}.include?( @paper ) )    
    assert_response 404
  end
end
