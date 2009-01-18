require File.dirname(__FILE__) + '/../test_helper'

class PapersControllerTest < ActionController::TestCase
  def test_on_index_with_not_logged_should_show_only_visible
    get :index
    assert_response :success
    assert_not_nil assigns(:papers)
    assert( !assigns(:papers).include?( papers(:paper1) ) )
    assert( assigns(:papers).include?( papers(:paper2) ) )
  end

  def test_on_index_with_logged_but_not_admin_should_show_only_visible
    login_as users(:user1)
    
    get :index
    assert_response :success
    assert_not_nil assigns(:papers)
    assert( !assigns(:papers).include?( papers(:paper1) ) )
    assert( assigns(:papers).include?( papers(:paper2) ) )
  end

  def test_on_index_with__admin_should_show_all
    login_as users(:user3)
    
    get :index
    assert_response :success
    assert_not_nil assigns(:papers)
    assert( assigns(:papers).include?( papers(:paper1) ) )
    assert( assigns(:papers).include?( papers(:paper2) ) )
  end

  def test_on_new_with_logged_should_get_new
    login_as users(:user1)
    get :new
    assert_response :success
  end

  def test_on_new_with_not_logged_should_redirect_to_new_session
    get :new
    assert_redirected_to new_session_path
  end

  def test_on_create_with_logged_should_create_paper
    login_as users(:user1)
    
    assert_difference('Paper.count') do
      post(
        :create, 
        :paper => { 
          :title        => "Paper Title",
          :description  => "Paper description",
          :family       => Paper::FAMILY[:TUTORIAL],
          :status       => Paper::STATUS[:PROPOSED],
          :minutes      => 0
        }
      )
    end

    assert_redirected_to paper_path(assigns(:paper))
  end
  
  def test_on_create_with_not_logged_should_redirect_to_new_session
    assert_difference('Paper.count', 0) do
      post(
        :create, 
        :paper => { 
          :title        => "Paper Title",
          :description  => "Paper description",
          :family       => Paper::FAMILY[:TUTORIAL],
          :status       => Paper::STATUS[:PROPOSED],
          :minutes      => 0
        }
      )
    end

    assert_redirected_to new_session_path
  end

  def test_on_show_without_login_should_show_public_paper
    get :show, :id => papers(:paper2).id
    assert_response :success
  end

  def test_on_show_without_login_should_not_show_not_public_paper
    get :show, :id => papers(:paper1).id
    assert_response 404
  end

  def test_with_login_should_show_public_paper
    login_as users(:user1)
    get :show, :id => papers(:paper1).id
    assert_response :success
  end

  def test_with_login_should_not_show_not_public_paper
    login_as users(:user2)
    get :show, :id => papers(:paper1).id
    assert_response 404
  end

  def test_with_speaker_login_should_show_not_public_paper
    login_as users(:user1)
    get :show, :id => papers(:paper1).id
    assert_response :success
  end
  
  def test_with_admin_login_should_show_not_public_paper
    login_as users(:user3)
    get :show, :id => papers(:paper1).id
    assert_response :success
  end

  def test_on_edit_with_speaker_logged_should_get_edit
    login_as users(:user1)
    get :edit, :id => papers(:paper1).id
    assert_response :success
  end

  def test_on_edit_with_not_speaker_logged_should_response_404
    login_as users(:user2)
    get :edit, :id => papers(:paper1).id
    assert_response 404
  end

  def test_on_edit_with_admin_logged_should_get_edit
    login_as users(:user3)
    get :edit, :id => papers(:paper1).id
    assert_response :success
  end
  
  def test_on_edit_with_not_logged_should_redirect_to_new_session
    get :edit, :id => papers(:paper1).id
    assert_redirected_to new_session_path
  end

  def test_on_update_with_speaker_logged_should_update_paper
    @paper = papers(:paper1)
    login_as users(:user1)
    
    put :update, :id => @paper.id, :paper => { :title => 'another title' }
    
    @paper.reload
    assert_equal( 'another title', @paper.title )
    assert_redirected_to edit_paper_path(assigns(:paper))
  end

  def test_on_update_with_admin_logged_should_update_paper
    @paper = papers(:paper1)
    login_as users(:user3)
    
    put :update, :id => @paper.id, :paper => { :title => 'another title' }
    
    @paper.reload
    assert_equal( 'another title', @paper.title )
    assert_redirected_to edit_paper_path(assigns(:paper))
  end

  def test_on_update_with_not_speaker_logged_should_response_404
    @paper = papers(:paper1)
    login_as users(:user2)
    
    put :update, :id => @paper.id, :paper => { :title => 'another title' }
    
    @paper.reload
    assert_not_equal( 'another title', @paper.title )
    assert_response 404
  end
  
  def test_on_update_with_not_logged_should_redirect_to_new_session
    @paper = papers(:paper1)
    
    put :update, :id => @paper.id, :paper => { :title => 'another title' }
    
    @paper.reload
    assert_not_equal( 'another title', @paper.title )
    assert_redirected_to new_session_path
  end

  def test_on_update_status_with_speaker_logged_should_not_update_status
    @paper = papers(:paper1)
    login_as users(:user1)

    assert_not_equal( Paper::STATUS[:CONFIRMED], @paper.status )
    
    put :update, :id => @paper.id, :paper => { :status => Paper::STATUS[:CONFIRMED] }
    
    @paper.reload
    assert_not_equal( Paper::STATUS[:CONFIRMED], @paper.status )
    
    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path(assigns(:paper))
  end


  def test_on_update_status_with_speaker_logged_should_update_status_if_actual_is_acepted_and_wil_be_confirmed
    login_as users(:user1)

    @paper = papers(:paper1)
    @paper.status = Paper::STATUS[:ACEPTED]
    @paper.save
    
    put(
      :update_status, 
      :id => @paper.id,
      :status => Paper::STATUS[:CONFIRMED]
    )
    
    @paper.reload
    assert_equal( Paper::STATUS[:CONFIRMED], @paper.status )
    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path(assigns(:paper))

    # STATUS WAS NOT ACEPTED
    @paper = papers(:paper1)
    @paper.status = Paper::STATUS[:PROPOSED]
    @paper.save
    
    put(
      :update_status, 
      :id => @paper.id,
      :status => Paper::STATUS[:CONFIRMED]
    )
    
    @paper.reload
    assert_equal( Paper::STATUS[:PROPOSED], @paper.status )
    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path(assigns(:paper))
    
    # STATUS WAS ACEPTED BUT WILL NOT BE CONFIRMED
    @paper = papers(:paper1)
    @paper.status = Paper::STATUS[:ACEPTED]
    @paper.save
    
    put(
      :update_status, 
      :id => @paper.id,
      :status => Paper::STATUS[:UNDER_REVIEW]
    )
    
    @paper.reload
    assert_equal( Paper::STATUS[:ACEPTED], @paper.status )
    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path(assigns(:paper))
  end
  
  def test_on_update_status_with_admin_logged_should_update_status_to_any
    login_as users(:user3)

    @paper = papers(:paper1)
    @paper.status = Paper::STATUS[:ACEPTED]
    @paper.save
    
    put(
      :update_status, 
      :id => @paper.id,
      :status => Paper::STATUS[:CONFIRMED]
    )
    
    @paper.reload
    assert_equal( Paper::STATUS[:CONFIRMED], @paper.status )
    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path(assigns(:paper))

    # OTHER
    @paper = papers(:paper1)
    @paper.status = Paper::STATUS[:PROPOSED]
    @paper.save
    
    put(
      :update_status, 
      :id => @paper.id,
      :status => Paper::STATUS[:UNDER_REVIEW]
    )
    
    @paper.reload
    assert_equal( Paper::STATUS[:UNDER_REVIEW], @paper.status )
    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path(assigns(:paper))
  end

  def test_on_destroy_with_not_logged_should_redirect_to_new_session
    assert_difference('Paper.count', 0) do
      delete :destroy, :id => papers(:paper1).id
    end

    assert_redirected_to new_session_path
  end

  def test_on_destroy_with_not_admin_logged_should_response_404
    login_as users(:user1)
    
    assert_difference('Paper.count', 0) do
      delete :destroy, :id => papers(:paper1).id
    end

    assert_response 404
  end
  
  def test_on_destroy_with_admin_logged_should_destroy_paper
    login_as users(:user3)
    
    assert_difference('Paper.count', -1) do
      delete :destroy, :id => papers(:paper1).id
    end

    assert_redirected_to papers_path
  end
end
