class AddGithubUserAndTwitterUserToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :github_user, :string
    add_column :users, :twitter_user, :string
  end

  def self.down
    remove_column :users, :twitter_user
    remove_column :users, :github_user
  end
end
