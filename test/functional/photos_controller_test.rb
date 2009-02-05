require File.dirname(__FILE__) + '/../test_helper'

class PhotosControllerTest < ActionController::TestCase
  def test_on_create
    login_as users(:user1)
    
    @paper = papers(:paper1)
    assert_not_nil( @paper.photo.url =~ /missing.png/ )
    
    post(
      :create,
      :paper_id => @paper.id,
      :file => fixture_file_upload( "/photos/photo900x300.png", 'image/png' )
    )

    @paper.reload
    assert_nil( @paper.photo.url =~ /missing.png/ )
    assert_nil( @paper.photo.url(:medium) =~ /missing.png/ )
    assert_redirected_to edit_paper_path(@paper)
  end
  
  def test_on_create_with_not_logged_should_respodirected_to_new_session
    post( :create )
    assert_redirected_to new_session_path
  end
  
  def test_on_create_with_logged_but_not_speaker_should_response_404
    login_as users(:user2)
    post( :create, :paper_id => papers(:paper1) )
    assert_response 404
  end
  
  def test_on_create_with_logged_but_not_speaker_but_admin_should_redirected_to_edit
    login_as users(:user_admin)
    
    post(
      :create,
      :paper_id => papers(:paper1),
      :file => fixture_file_upload( "/photos/photo900x300.png", 'image/png' )
    )
    
    assert_not_nil( flash[:notice] )
    assert_redirected_to edit_paper_path( assigns(:paper) )
  end
end