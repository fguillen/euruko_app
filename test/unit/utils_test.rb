require 'utils'
require 'test/unit'

class UtilsTest < Test::Unit::TestCase
  def test_site_key_generator
    assert( Utils.site_key_generator )
    assert_not_equal( Utils.site_key_generator, Utils.site_key_generator )
  end
  
  def test_cents_to_euros
    assert_equal( "123.40", Utils.cents_to_euros( 12340 ) )
    assert_equal( "123.04", Utils.cents_to_euros( 12304 ) )
    assert_equal( "0.10", Utils.cents_to_euros( 10 ) )
  end
end