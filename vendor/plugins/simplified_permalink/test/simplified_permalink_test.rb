require 'test/unit'
require 'rubygems'
require 'active_record'
require 'simplified_permalink'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

def setup_db
  silence_stream(STDOUT) do
    ActiveRecord::Schema.define(:version => 1) do
      create_table :posts do |t|
        t.string :title_to_permalink
        t.string :permalink
        t.string :title_to_slug
        t.string :slug
      end
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Post < ActiveRecord::Base
  permalink :title_to_permalink
  permalink :title_to_slug, :slug
end

class SimplifiedPermalinkTest < Test::Unit::TestCase

  def setup
    setup_db
  end

  def teardown
    teardown_db
  end

  def test_should_convert_title_to_permalink_to_permalink
    flunk "test_should_convert_title_to_permalink_to_permalink"
    # post = Post.create :title_to_permalink => "Chunky Bacon"
    # assert_equal "chunky-bacon", post.permalink
  end

  def test_should_convert_title_to_slug_to_slug
    flunk "test_should_convert_title_to_slug_to_slug"
    # post = Post.create :title_to_slug => "Chunky Bacon"
    # assert_equal "chunky-bacon", post.slug
  end

end