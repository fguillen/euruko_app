require File.dirname(__FILE__) + '/../test_helper'

class LocationSearchsControllerTest < ActionController::TestCase
  def setup
    yahoo_xml = File.read( "#{RAILS_ROOT}/test/fixtures/yahoo_places.xml" )
    YahooGeoplanetSearchWrapper.stubs( :send_search ).returns( yahoo_xml )
  end
  
  def test_on_create_should_render_results_partial
    post(
      :create,
      :query => 'wadus'
    )
    
    assert_response :success
    assert_not_nil( assigns(:places) )
    assert_equal( 5, assigns(:places).size )
    assert_template 'location_searchs/_places'
  end
end