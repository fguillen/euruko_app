require 'rubygems'
require 'active_record'
require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + '/../lib/simple_text_fields')

db_file = Tempfile.new("db")

ActiveRecord::Base.establish_connection({:adapter => 'sqlite3', :dbfile => db_file.path})
ActiveRecord::Schema.define do
  create_table :my_models, :force => true do |t|
    t.column :title, :string
    t.column :body, :text
  end
end

class MyModel < ActiveRecord::Base
  simple_text_fields :only => :title
end

class ActsWithoutScriptsTest < Test::Unit::TestCase
  
  def test_removing_tags
    text  = '<h1>this is the title</h1>'
    
    post = MyModel.create!(:title => text, :body => text)
    assert_equal('this is the title', post.title)
    assert_equal(text, post.body)
    
    text = '&lt;h1&gt;this is the title&lt;/h1&gt;'
    
    post = MyModel.create!(:title => text, :body => text)
    assert_equal(text, post.title)
    assert_equal(text, post.body)
  end
end