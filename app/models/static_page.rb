class StaticPage < ActiveRecord::Base
  # permalink :title
  
  validates_presence_of  :title, :content, :permalink
  validates_uniqueness_of :title, :permalink
  validates_format_of :permalink, :with => /^[A-z_\-0-9]*$/
  
  def to_param
    self.permalink
  end
end
