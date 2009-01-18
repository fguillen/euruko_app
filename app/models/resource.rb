class Resource < ActiveRecord::Base
  belongs_to :paper
  belongs_to :user
  
  validates_presence_of :url
  validates_presence_of :user_id
  validates_presence_of :paper_id
  validates_uniqueness_of :url, :scope => :paper_id, :message => 'This Paper has already this resource associated'
  
  def self.save_file( paper_id, file_blob )
    path_relative = "resources/#{paper_id}/#{file_blob.original_filename}"
    path = "#{RAILS_ROOT}/public/#{path_relative}"
    
    FileUtils.mkdir_p( File.dirname( path ) )
    File.open( path, "w" ) { |f| f.write( file_blob.read ) }
    
    return path_relative
  end
  
  def url_link
    return "http://#{APP_CONFIG['site_url']}/#{self.url}"   if self.is_local
    return self.url                                         if !self.is_local
  end
end
