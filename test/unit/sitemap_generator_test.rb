require File.dirname(__FILE__) + '/../test_helper'

class SitemapGeneratorTest < ActiveSupport::TestCase
  def test_do
    Paper.delete_all
    User.delete_all
    StaticPage.delete_all

    User.stubs(:per_page).returns(1)

    user_1 = Factory(:user, :public_profile => true, :activated_at => Time.parse( '2010-01-01' ), :id => 1, :name => 'User 1')
    user_2 = Factory(:user, :public_profile => true, :activated_at => Time.parse( '2010-01-01' ), :id => 2, :name => 'User 2')

    event = Factory(:event, :id => 1)
    cart = Factory(:cart, :user => user_1, :status => Cart::STATUS[:COMPLETED] )
    carts_events = Factory(:carts_event, :cart => cart, :event => event )

    paper_1 = Factory( :paper, :title => 'paper 1', :status => Paper::STATUS[:CONFIRMED], :family => Paper::FAMILY[:TUTORIAL], :creator => user_1, :id => 1 )
    paper_2 = Factory( :paper, :title => 'paper 2', :status => Paper::STATUS[:CONFIRMED], :family => Paper::FAMILY[:TUTORIAL], :creator => user_1, :id => 2 )

    speaker = Factory( :speaker, :user => user_1, :paper => paper_1 )

    static_page_1 = Factory( :static_page, :title => 'static page', :permalink => 'static_page' )

    # File.open( "#{RAILS_ROOT}/test/fixtures/sitemap.xml", 'w' ) do |f|
    #   f.write SitemapGenerator.do
    # end

    assert_equal( File.read( "#{RAILS_ROOT}/test/fixtures/sitemap.xml" ), SitemapGenerator.do )
  end
end