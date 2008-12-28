class Resource < ActiveRecord::Base
  belongs_to :paper
  belongs_to :user
  
  validates_presence_of :url
  validates_presence_of :user_id
  validates_presence_of :paper_id
  validates_uniqueness_of :url, :scope => :paper_id, :message => 'This Paper has already this resource associated'
  
  def self.save_file( paper_id, file_blob )
    path = "#{RAILS_ROOT}/public/resources/#{paper_id}/#{file_blob.original_filename}"
    FileUtils.mkdir_p( File.dirname( path ) )
    File.open( path, "w" ) { |f| f.write( file_blob.read ) }
    
    return path
  end
end
