require 'utils'
require 'test/unit'

class UtilsTest < Test::Unit::TestCase
  def test_site_key_generator
    assert( Utils.site_key_generator )
    assert_not_equal( Utils.site_key_generator, Utils.site_key_generator )
  end
end