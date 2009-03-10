require File.dirname(__FILE__) + '/../test_helper'


class YahooGeoplanetSearchWrapperTest < ActiveSupport::TestCase
  def setup
    yahoo_xml = File.read( "#{RAILS_ROOT}/test/fixtures/yahoo_places.xml" )
    YahooGeoplanetSearchWrapper.stubs( :send_search ).returns( yahoo_xml )
  end
  
  def test_search
    places = YahooGeoplanetSearchWrapper.search( 'pepe', APP_CONFIG[:yahoo_id] )
    assert_equal( 5, places.size )
    assert_not_nil( places[0][:name] )
    assert_not_nil( places[0][:admin1] )
    assert_not_nil( places[0][:admin2] )
    # assert_not_nil( places[0][:pc] )
    assert_not_nil( places[0][:country] )
  end
  
  def test_place_to_s
    @place = YahooGeoplanetSearchWrapper.search( 'pepe', APP_CONFIG[:yahoo_id] )[2]
    @place_s = YahooGeoplanetSearchWrapper.place_to_s( @place )
    assert_equal( 'Madrid, Augusta, Virginia, United States', @place_s )
  end
  
end