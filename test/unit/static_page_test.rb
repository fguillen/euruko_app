require 'test_helper'

class StaticPageTest < ActiveSupport::TestCase
  def setup
    @static_page = static_pages(:static_page1)
  end

  def test_create
    assert_difference "StaticPage.count", 1 do
      StaticPage.create(
        :title      => 'title',
        :content    => 'content',
        :permalink  => 'permalink'
      )
    end
  end
end
