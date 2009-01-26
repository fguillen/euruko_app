require File.dirname(__FILE__) + '/../test_helper'

class VotesControllerTest < ActionController::TestCase
  def test_when_logged_should_create_vote
    login_as users(:user1)

    assert_difference('Vote.count') do
      post(
        :create, 
        :paper_id => papers(:paper2).id, 
        :points => 2
      )
    end
    
    assert_not_nil( flash[:notice] )
    assert_redirected_to paper_path( papers(:paper2) )
  end

  def test_when_logged_should_update_vote
    login_as users(:user1)
    @vote = votes(:vote1)
    assert_not_equal( 2, @vote.points )
    
    put(
      :create,
      :paper_id => @vote.paper_id, 
      :points   => '2'
    )
    
    @vote.reload
    assert_equal( 2, @vote.points )
    assert_redirected_to paper_path( papers(:paper1) )
    assert_not_nil( flash[:notice] )
    assert_nil( flash[:error] )
  end
  
  def test_when_not_logged_should_not_create_vote
    assert_difference('Vote.count', 0) do
      post(
        :create, 
        :paper_id => papers(:paper2).id, 
        :points => 2
      )
    end
    
    assert_nil( flash[:notice] )
    assert_not_nil( flash[:error] )
    assert_redirected_to new_session_path
  end
  

  def test_on_create_with_js_should_render_partial_and_not_set_flash
    login_as users(:user1)

    assert_difference('Vote.count') do
      post(
        :create, 
        :paper_id => papers(:paper2).id, 
        :points => 2,
        :format => 'js'
      )
    end
    
    assert_nil( flash[:error] )
    assert_nil( flash[:notice] )

    assert_response :success
    assert_template 'papers/_valorations.html.erb'
  end
end
