require File.dirname(__FILE__) + '/../test_helper'

class SpeakersControllerTest < ActionController::TestCase
  def test_should_get_index
    # get :index
    # assert_response :success
    # assert_not_nil assigns(:speakers)
  end

  def test_on_create_and_logged_and_speaker_should_create
    @paper = papers(:paper1)
    login_as users(:user1)
    
    assert( !@paper.speakers.collect{|s| s.user}.include?( users(:user2) ) )
    
    assert_difference('Speaker.count') do
      post( 
        :create,
        :paper_id    => @paper.id,
        :speaker => {
          :user_id     => users(:user2).id 
        }
      )
    end
    
    @paper.reload
    assert( @paper.speakers.collect{|s| s.user}.include?( users(:user2) ) )
    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path( papers(:paper1) )
  end

  def test_on_create_and_logged_and_not_speaker_but_admin_should_create
    @paper = papers(:paper1)
    login_as users(:user_admin)
    
    assert( !@paper.speakers.collect{|s| s.user}.include?( users(:user2) ) )
    
    assert_difference('Speaker.count') do
      post( 
        :create,
        :paper_id    => @paper.id,
        :speaker => {
          :user_id     => users(:user2).id 
        }
      )
    end
    
    @paper.reload
    assert( @paper.speakers.collect{|s| s.user}.include?( users(:user2) ) )
    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path( papers(:paper1) )
  end

  def test_on_create_and_logged_but_not_speaker_and_no_admin_should_404
    @paper = papers(:paper1)
    login_as users(:user2)
    
    assert( !@paper.speakers.collect{|s| s.user}.include?( users(:user2) ) )
    
    assert_difference('Speaker.count', 0) do
      post( 
        :create,
        :paper_id    => @paper.id,
        :speaker => {
          :user_id     => users(:user2).id 
        }
      )
    end
    
    @paper.reload
    assert( !@paper.speakers.collect{|s| s.user}.include?( users(:user2) ) )
    assert_nil( flash[:notice] )
    assert_response 404
  end

  def test_on_destroy_and_logged_and_speaker_should_destroy_speaker
    @paper = papers(:paper1)
    login_as users(:user1)

    assert( @paper.speakers.collect{|s| s.user}.include?( users(:user1) ) )
    
    assert_difference('Speaker.count', -1) do
      delete(
        :destroy, 
        :paper_id => @paper.id,
        :id => speakers(:speaker_user1_paper1).id
      )
    end

    @paper.reload
    assert( !@paper.speakers.collect{|s| s.user}.include?( users(:user1) ) )
    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path( papers(:paper1) )
  end
  
  def test_on_destroy_and_logged_and_not_speaker_but_admin_should_destroy_speaker
    @paper = papers(:paper1)
    login_as users(:user_admin)

    assert( @paper.speakers.collect{|s| s.user}.include?( users(:user1) ) )
    
    assert_difference('Speaker.count', -1) do
      delete(
        :destroy, 
        :paper_id => @paper.id,
        :id => speakers(:speaker_user1_paper1).id
      )
    end

    @paper.reload
    assert( !@paper.speakers.collect{|s| s.user}.include?( users(:user1) ) )
    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path( papers(:paper1) )
  end
  
  def test_on_destroy_and_logged_and_not_speaker_and_not_admin_should_404
    @paper = papers(:paper1)
    login_as users(:user2)

    assert( @paper.speakers.collect{|s| s.user}.include?( users(:user1) ) )
    
    assert_difference('Speaker.count', 0) do
      delete(
        :destroy, 
        :paper_id => @paper.id,
        :id => speakers(:speaker_user1_paper1).id
      )
    end

    @paper.reload
    assert( @paper.speakers.collect{|s| s.user}.include?( users(:user1) ) )
    assert_nil( flash[:notice] )
    assert_response 404
  end
  
  def test_on_create_with_js_ok
    login_as users(:user1)
    
    post( 
      :create,
      :paper_id => papers(:paper1),
      :speaker  => { :user_id => users(:user2).id },
      :format   => 'js'
    )
    
    assert_response :success
    assert_nil( flash[:notice] )
    assert_nil( flash[:error] )
    assert_template 'papers/_speakers_edit'
  end
  
  def test_on_create_with_js_error
    login_as users(:user1)
    
    post( 
      :create,
      :paper_id => papers(:paper1),
      :speaker  => { :user_id => users(:user1).id },
      :format   => 'js'
    )
    
    assert_response :unprocessable_entity
    assert_nil( flash[:notice] )
    assert_nil( flash[:error] )
    assert_template 'papers/_speakers_edit'
  end
  
  def test_on_destroy_with_js_ok
    login_as users(:user1)
    
    post( 
      :destroy,
      :paper_id => papers(:paper1),
      :id => speakers(:speaker_user1_paper1).id,
      :format   => 'js'
    )
    
    assert_response :success
    assert_nil( flash[:notice] )
    assert_nil( flash[:error] )
    assert_template 'papers/_speakers_edit'
  end
  
  def test_on_destroy_with_js_error
    login_as users(:user2)
    
    post( 
      :destroy,
      :paper_id => papers(:paper1),
      :id => speakers(:speaker_user1_paper1).id,
      :format   => 'js'
    )
    
    assert_response 404
    assert_nil( flash[:notice] )
    assert_nil( flash[:error] )
  end
end
