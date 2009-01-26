require File.dirname(__FILE__) + '/../test_helper'

class CommentsControllerTest < ActionController::TestCase
  
  def test_when_logged_should_create_comment
    login_as users(:user1)
    
    assert_difference('Comment.count') do
      post(
        :create, 
        :paper_id => papers(:paper2).id,
        :comment => { :text => 'text' }
      )
    end
    assert_redirected_to paper_path( papers(:paper2) )
  end
  
  def test_when_not_logged_on_create_should_redirect_to_new_session
    assert_difference('Comment.count', 0) do
      post(
        :create, 
        :paper_id => papers(:paper2).id,
        :comment => { :text => 'text' }
      )
    end
    assert_redirected_to new_session_path
  end
  
  def test_on_create_with_format_js_should_render_partial
    login_as users(:user1)
    
    post(
      :create, 
      :paper_id => papers(:paper2).id,
      :comment => { :text => 'text'},
      :format => 'js'
    )

    assert_response :success
    assert_template 'papers/_comment'
  end
  
  def test_on_create_with_format_js_and_with_error_should_render_error_partial
    ActionView::Base.any_instance.expects(:render).with(:partial => 'papers/comment_error')
    login_as users(:user1)
    
    post(
      :create, 
      :paper_id => papers(:paper2).id,
      :comment => { :text => '' },
      :format => 'js'
    )

    assert_response :unprocessable_entity
    assert_template 'papers/_comment_error'
  end
  
  def test_on_create_with_format_js_and_with_error_should_render_error_partial
    login_as users(:user1)
    
    post(
      :create, 
      :paper_id => papers(:paper2).id,
      :comment => { :text => '' },
      :format => 'js'
    )

    assert_response :unprocessable_entity
    assert_template 'papers/_comment_error'
  end
  
  def test_on_create_with_format_js_should_not_set_flash
    login_as users(:user1)

    post(
      :create, 
      :paper_id => papers(:paper2).id,
      :comment => { :text => 'text' },
      :format => 'js'
    )

    assert_response :success
    assert_nil( flash[:error] )
    assert_nil( flash[:notice] )

    
    post(
      :create, 
      :paper_id => papers(:paper2).id,
      :comment => { :text => '' },
      :format => 'js'
    )

    assert_response :unprocessable_entity
    assert_nil( flash[:error] )
    assert_nil( flash[:notice] )
  end
end
