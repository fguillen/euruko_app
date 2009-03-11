require File.dirname(__FILE__) + '/../test_helper'

class TwitterWrapperTest < ActiveSupport::TestCase
  def test_on_post_when_ok_should_response_ok
    Net::HTTP.any_instance.expects(:request).returns( Net::HTTPSuccess.new( nil, nil, nil ) ).once
    assert_equal( "OK", TwitterWrapper.post( "yes we can.." ) )
  end
  
  # def test_on_post_when_error_should_raise_exception
  #   Net::HTTP.any_instance.expects(:request).returns( Net::HTTPUnauthorized.new( nil, nil, nil ) ).once
  #   assert_raise( Net::HTTPServerException ) { TwitterWrapper.post( "yes we can.." ) }
  # end
end
