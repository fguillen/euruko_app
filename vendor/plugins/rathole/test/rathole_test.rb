require File.expand_path(File.dirname(__FILE__) + "/helper")

class RatholeTest < RatholeTestCase
  def test_can_identify_strings
    assert_equal(Fixtures.identify("foo"), Fixtures.identify("foo"))
    assert_not_equal(Fixtures.identify("foo"), Fixtures.identify("FOO"))
  end
  
  def test_can_identify_symbols
    assert_equal(Fixtures.identify(:foo), Fixtures.identify(:foo))
  end
end
