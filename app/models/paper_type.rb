class PaperType < ActiveRecord::Base
  has_many :papers
  
  validates_presence_of :name
end
