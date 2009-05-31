require File.dirname(__FILE__) + '/../test_helper'

class UtilsTest < ActiveSupport::TestCase
  def test_site_key_generator
    assert( Utils.site_key_generator )
    assert_not_equal( Utils.site_key_generator, Utils.site_key_generator )
  end
  
  def test_cents_to_euros
    assert_equal( "123.40", Utils.cents_to_euros( 12340 ) )
    assert_equal( "123.04", Utils.cents_to_euros( 12304 ) )
    assert_equal( "0.10", Utils.cents_to_euros( 10 ) )
  end
  
  def test_total_without_tax
    [3000, 1000, 123].each do |q|
      assert_equal( 
        q * 100 / (100 + APP_CONFIG[:tax_percent].to_f), 
        Utils.total_without_tax( q )
      )
    end
  end
  
  def test_total_tax
    [3000, 1000, 123].each do |q|
      assert_equal( 
        q * APP_CONFIG[:tax_percent].to_f / (100 + APP_CONFIG[:tax_percent].to_i), 
        Utils.total_tax( q )
      )
    end
  end
  
  def test_total_without_tax_add_to_total_tax_should_be_the_total
    [3000, 1000, 123].each do |q|
      assert_equal( 
        q,
        Utils.total_without_tax( q ) + Utils.total_tax( q )
      )    
    end
  end
  
  def test_total_without_tax_on_euros_add_to_total_tax_on_euros_should_be_the_total_on_euros
    [3000, 1000, 123].each do |q|
      total_without_tax_on_euros = Utils.cents_to_euros( Utils.total_without_tax( q ) )
      total_tax_on_euros = Utils.cents_to_euros( Utils.total_tax( q ) )
      assert_equal( q.to_f/100, total_without_tax_on_euros.to_f + total_tax_on_euros.to_f )
    end
  end
end