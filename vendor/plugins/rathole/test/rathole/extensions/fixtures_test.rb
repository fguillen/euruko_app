require File.expand_path(File.dirname(__FILE__) + "/../../helper")

class Rathole::Extensions::FixturesTest < RatholeTestCase
  TIMESTAMP_PROPERTIES = %w(created_at created_on updated_at updated_on)
  
  def test_should_populate_columns_if_they_exist
    TIMESTAMP_PROPERTIES.each do |property|
      assert_not_nil(timestamp = monkeys(:george).send(property), "should set #{property}")
    end
  end
  
  def test_should_populate_all_columns_with_the_same_time
    last = nil
    
    TIMESTAMP_PROPERTIES.each do |property|
      current = monkeys(:george).send(property)
      last ||= current
      
      assert_equal(last, current)
      last = current
    end
  end
  
  def test_should_only_populate_columns_that_exist
    assert_not_nil(pirates(:blackbeard).created_on)
    assert_not_nil(pirates(:blackbeard).updated_on)
  end
  
  def test_should_not_overwrite_fixture_data
    assert_equal(2.weeks.ago.to_date, pirates(:redbeard).created_on.to_date)
    assert_equal(2.weeks.ago.to_date, pirates(:redbeard).updated_on.to_date)
  end
  
  def test_should_generate_unique_ids
    assert_not_nil(monkeys(:george).id)
    assert_not_equal(monkeys(:george).id, monkeys(:louis).id)
  end
  
  def test_should_resolve_belongs_to_symbols
    assert_equal(monkeys(:george), pirates(:blackbeard).monkey)
  end

  def test_should_support_join_tables
    assert(pirates(:blackbeard).monkeys.include?(monkeys(:george)))
    assert(pirates(:blackbeard).monkeys.include?(monkeys(:louis)))
    assert(monkeys(:george).pirates.include?(pirates(:blackbeard)))
  end
  
  def test_supports_inline_habtm
    assert(monkeys(:george).fruits.include?(fruits(:apple)))
    assert(monkeys(:george).fruits.include?(fruits(:orange)))
    assert(!monkeys(:george).fruits.include?(fruits(:grape)))
  end
  
  def test_supports_yaml_arrays
    assert(monkeys(:louis).fruits.include?(fruits(:apple)))
    assert(monkeys(:louis).fruits.include?(fruits(:orange)))
  end
  
  def test_strips_DEFAULTS_key
    assert_raise(StandardError) { monkeys(:DEFAULTS) }
    
    # this lets us do YAML defaults and not have an extra fixture entry
    %w(orange grape).each { |f| assert(monkeys(:davey).fruits.include?(fruits(f))) }
  end
  
  def test_supports_label_interpolation
    assert_equal("frederick", monkeys(:frederick).name)
  end
end
