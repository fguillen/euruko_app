require File.dirname(__FILE__) + '/../test_helper'

class PhotosControllerTest < ActionController::TestCase
  def test_on_create
    login_as users(:user1)
    
    @paper = papers(:paper1)
    assert_not_nil( @paper.photo.url =~ /missing.png/ )
    
    post(
      :create,
      :paper_id => @paper.id,
      :file => fixture_file_upload( "/photos/photo.png", 'image/png' )
    )

    @paper.reload
    assert_nil( @paper.photo.url =~ /missing.png/ )
    assert_nil( @paper.photo.url(:medium) =~ /missing.png/ )
    assert_redirected_to edit_paper_path(@paper)
  end
  
  def test_on_create_with_not_logged_should_response_404
    flunk
  end
  
  def test_on_create_with_logged_but_not_speaker_should_response_404
    flunk
  end
  
  def test_on_create_with_logged_but_not_speaker_but_admin_should_response_success
    flunk
  end
  
  def test_on_create_on_a_paper_with_already_a_photo_should_update_it
    flunk
  end
end