require File.dirname(__FILE__) + '/../test_helper'

class SitemapsControllerTest < ActionController::TestCase
  def test_show
    SitemapGenerator.expects(:do).returns( 'wadus sitemap' )
    
    get( :show )
    
    assert_response :success
    assert_equal( 'wadus sitemap', @response.body )
    assert_equal( 'text/xml', @response.content_type )
  end
end