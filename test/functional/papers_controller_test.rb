require File.dirname(__FILE__) + '/../test_helper'

class PapersControllerTest < ActionController::TestCase
  def test_on_index_with_not_logged_should_show_only_visible
    get :index
    assert_response :success
    assert_not_nil assigns(:papers)
    assert( !assigns(:papers).include?( papers(:paper3) ) )
    assert( assigns(:papers).include?( papers(:paper2) ) )
  end

  def test_on_index_with_logged_but_not_admin_should_show_only_visible
    login_as users(:user1)
    
    get :index
    assert_response :success
    assert_not_nil assigns(:papers)
    assert( !assigns(:papers).include?( papers(:paper3) ) )
    assert( assigns(:papers).include?( papers(:paper2) ) )
  end

  def test_on_index_with__admin_should_show_all
    login_as users(:user_admin)
    
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

  def test_new_should_not_show_form_to_private_profiles
    login_as users(:private)
    get :new
    assert_redirected_to edit_user_path( users(:private) )
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

    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path(assigns(:paper))
  end

  def test_on_create_with_logged_should_assign_the_new_paper_to_current_user_when_user_is_not_admin
    @user = users(:user1)
    login_as @user
    
    assert_difference( 'Speaker.count' ) do
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
    end

    @paper = Paper.find_by_title( "Paper Title" )
    assert( @paper.speakers.collect{ |s| s.user}.include?( @user ) )
    assert( @user.speaker_on.include?( @paper ) )
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
    get :show, :id => papers(:paper3).id
    assert_response 404
  end

  def test_on_show_with_login_should_show_public_paper
    login_as users(:user1)
    get :show, :id => papers(:paper1).id
    assert_response :success
  end

  def test_on_show_with_login_should_not_show_not_public_paper
    login_as users(:private)
    get :show, :id => papers(:paper3).id
    assert_response 404
  end

  def test_on_show_with_speaker_login_should_show_not_public_paper
    login_as users(:user1)
    get :show, :id => papers(:paper1).id
    assert_response :success
  end
  
  def test_on_show_with_admin_login_should_show_not_public_paper
    login_as users(:user_admin)
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
    login_as users(:user_admin)
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
    login_as users(:user_admin)
    
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
    login_as users(:user_admin)

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
    login_as users(:user_admin)
    
    assert_difference('Paper.count', -1) do
      delete :destroy, :id => papers(:paper1).id
    end

    assert_redirected_to papers_path
  end
  
  def test_on_create_should_initialize_creator_id
    login_as users(:user1)
    
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
    
    assert_equal( users(:user1).id, assigns(:paper).creator.id)
  end
  
  def test_on_update_with_not_admin_should_not_update_protected_attributes
    login_as users(:user1)
    @paper = papers(:paper1)
    
    assert_not_equal( Paper::STATUS[:PROPOSED], @paper.status )
    assert_not_equal( 0, @paper.minutes )
    assert_not_equal( Paper::FAMILY[:SESSION], @paper.family )
    assert_not_equal( rooms(:room2), @paper.room )
    assert_not_equal( 2001, @paper.date.year )
    
    post(
      :update,
      :id => @paper.id, 
      :paper => { 
        :status       => Paper::STATUS[:PROPOSED],
        :minutes      => 0,
        :family       => Paper::FAMILY[:SESSION],
        :room_id      => rooms(:room2).id,
        :date         => '2001-01-01 01:01'
      }
    )
    
    @paper.reload
    assert_not_equal( Paper::STATUS[:PROPOSED], @paper.status )
    assert_not_equal( 0, @paper.minutes )
    assert_not_equal( Paper::FAMILY[:SESSION], @paper.family )
    assert_not_equal( rooms(:room2), @paper.room )
    assert_not_equal( 2001, @paper.date.year )
  end
  
  def test_on_update_with_admin_should_update_protected_attributes
    login_as users(:user_admin)
    @paper = papers(:paper1)
    
    assert_not_equal( Paper::STATUS[:PROPOSED], @paper.status )
    assert_not_equal( 0, @paper.minutes )
    assert_not_equal( Paper::FAMILY[:SESSION], @paper.family )
    assert_not_equal( rooms(:room2), @paper.room )
    assert_not_equal( 2001, @paper.date.year )
    
    post(
      :update,
      :id => @paper.id, 
      :paper => { 
        :status       => Paper::STATUS[:PROPOSED],
        :minutes      => 0,
        :family       => Paper::FAMILY[:SESSION],
        :room_id      => rooms(:room2).id,
        :date_form    => '2001/01/01',
        :time_form    => '10:10'
      }
    )
    
    @paper.reload
    assert_equal( Paper::STATUS[:PROPOSED], @paper.status )
    assert_equal( 0, @paper.minutes )
    assert_equal( Paper::FAMILY[:SESSION], @paper.family )
    assert_equal( rooms(:room2), @paper.room )
    assert_equal( 2001, @paper.date.year )
  end
  
  def test_on_update_with_not_admin_if_paper_status_is_under_review_can_not_be_updated
    login_as users(:user1)
    
    @paper = papers(:paper1)
    @paper.update_attribute( :status, Paper::STATUS[:UNDER_REVIEW] )
    
    post(
      :update,
      :id => @paper.id,
      :paper => { :title => 'other title' }
    )
    
    @paper.reload
    assert_not_equal( 'other title', @paper.title )
    assert_not_nil( flash[:error] )
    assert_redirected_to paper_path( @paper )
  end
  
  def test_on_update_with_admin_if_paper_status_is_under_review_can_be_updated
    login_as users(:user_admin)
    
    @paper = papers(:paper1)
    @paper.update_attribute( :status, Paper::STATUS[:UNDER_REVIEW] )
    
    post(
      :update,
      :id => @paper.id,
      :paper => { :title => 'other title' }
    )
    
    @paper.reload
    assert_equal( 'other title', @paper.title )
    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path( @paper )
  end
  
  def test_on_edit_with_not_admin_if_paper_status_is_under_review_should_redirected_to_show_with_error_flash
    login_as users(:user1)
    
    @paper = papers(:paper1)
    @paper.update_attribute( :status, Paper::STATUS[:UNDER_REVIEW] )
    
    get( :edit, :id => papers(:paper1).id )
    assert_not_nil( flash[:error] )
    assert_redirected_to paper_path( papers(:paper1) )
  end
  
  def test_on_edit_with_admin_if_paper_status_is_under_review_should_response_success
    login_as users(:user_admin)
    
    @paper = papers(:paper1)
    @paper.update_attribute( :status, Paper::STATUS[:UNDER_REVIEW] )
    
    get( :edit, :id => papers(:paper1).id )
    assert_nil( flash[:error] )
    assert_response :success
  end
  
  def test_on_index_with_not_admin_shoud_not_show_breaks
    get( :index )
    assert_not_nil( assigns(:papers) )
    assert( !assigns(:papers).include?( papers(:paper_break) ) )
  end
  
  def test_on_index_with_admin_shoud_show_breaks
    login_as users(:user_admin)
    get( :index )
    assert_not_nil( assigns(:papers) )
    assert( assigns(:papers).include?( papers(:paper_break) ) )
  end
  
  def test_on_create_with_not_admin_should_ignore_family_date_status_room_minutes
    @user = users(:user1)
    login_as @user
    
    assert_difference( 'Speaker.count' ) do
      assert_difference('Paper.count') do
        post(
          :create, 
          :paper => { 
            :title        => "Paper Title",
            :description  => "Paper description",
            :family       => Paper::FAMILY[:TUTORIAL],
            :status       => Paper::STATUS[:ACEPTED],
            :minutes      => 30,
            :room_id      => rooms(:room1).id,
            :date_form    => '2009/10/10',
            :time_form    => '10:10',
          }
        )
      end
    end

    @paper = assigns(:paper)
    assert_equal( users(:user1), @paper.creator )
    assert_equal( 'Paper Title', @paper.title )
    assert_equal( 'Paper description', @paper.description )
    assert_equal( Paper::FAMILY[:SESSION], @paper.family )
    assert_equal( Paper::STATUS[:PROPOSED], @paper.status )
    assert_equal( 0, @paper.minutes )
    assert_nil( @paper.room )
    assert_nil( @paper.date )
  end
  
  def test_on_create_with_admin_should_initialize_everything
    @user = users(:user_admin)
    login_as @user
    
    assert_difference('Paper.count') do
      post(
        :create, 
        :paper => { 
          :title        => "Paper Title",
          :description  => "Paper description",
          :family       => Paper::FAMILY[:TUTORIAL],
          :status       => Paper::STATUS[:ACEPTED],
          :minutes      => 30,
          :room_id      => rooms(:room1).id,
          :date_form    => '2009/10/10',
          :time_form    => '10:10',
        }
      )
    end

    @paper = assigns(:paper)
    assert_equal( users(:user_admin), @paper.creator )
    assert_equal( 'Paper Title', @paper.title )
    assert_equal( 'Paper description', @paper.description )
    assert_equal( Paper::FAMILY[:TUTORIAL], @paper.family )
    assert_equal( Paper::STATUS[:ACEPTED], @paper.status )
    assert_equal( 30, @paper.minutes )
    assert_equal( rooms(:room1), @paper.room )
    assert_equal( 2009, @paper.date.year )
    assert_equal( 10, @paper.date.month )
    assert_equal( 10, @paper.date.day )
    assert_equal( 10, @paper.date.hour )
    assert_equal( 10, @paper.date.min )
  end
  
  def test_on_index_with_status_param_should_charge_only_papers_on_this_status
    login_as users(:user_admin)
    
    get :index
    
    assert_response :success
    assert_not_nil assigns(:papers)
    assert( assigns(:papers).include?( papers(:paper1) ) )
    assert( assigns(:papers).include?( papers(:paper2) ) )
    assert( assigns(:papers).include?( papers(:paper3) ) )
    assert( assigns(:papers).include?( papers(:paper4) ) )
    
    get(
      :index,
      :status => Paper::STATUS[:ACEPTED]
    )

    assert_response :success
    assert_not_nil assigns(:papers)
    assert( assigns(:papers).include?( papers(:paper1) ) )
    assert( assigns(:papers).include?( papers(:paper2) ) )
    assert( !assigns(:papers).include?( papers(:paper3) ) )
    assert( !assigns(:papers).include?( papers(:paper4) ) )
  end
end
