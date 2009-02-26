require File.dirname(__FILE__) + '/../test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  def test_on_show_should_render_the_correct_view
    get :show, :id => 'help'
    assert_response :success
    assert_template 'static_pages/help'
  end
end