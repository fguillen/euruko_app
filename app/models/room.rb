class Room < ActiveRecord::Base
  permalink :name

  validates_uniqueness_of :name
  validates_presence_of :name
  
  simple_text_fields
end
