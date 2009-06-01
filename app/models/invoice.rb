class Invoice < ActiveRecord::Base
  belongs_to :cart
  
  validates_presence_of :cart_id
  validates_presence_of :path
  validates_presence_of :date
  validates_presence_of :serial
  validates_uniqueness_of :cart_id
  validates_uniqueness_of :path
  validates_uniqueness_of :serial
  
  before_destroy :delete_pdf_file
  
  def url_path
    self.path.gsub( "#{RAILS_ROOT}//public", '' )
  end
  
  def self.print( cart )
    invoice = nil
    
    Invoice.transaction do
      invoice = Invoice.new()
      invoice.date = Time.now
      invoice.cart = cart
      invoice.serial = Invoice.get_next_serial
      invoice.path =
        "#{RAILS_ROOT}/" + 
        "#{APP_CONFIG[:invoices_pdf_path]}/" +
        "#{Digest::MD5.hexdigest( "#{Time.now}#{rand}" )}_" +
        "#{APP_CONFIG[:invoices_serial_prefix]}#{invoice.serial}.pdf"
    
      PDFGenerator.create_pdf_invoice( invoice )
    
      invoice.save!
    end
    
    return invoice
  end
  
  def self.get_next_serial
    last_invoice = Invoice.find(:first, :select => 'serial', :order => 'serial desc')
    
    if last_invoice
      return Kernel.sprintf( "%03d", (last_invoice.serial.to_i + 1) )
    else
      return Kernel.sprintf( "%03d", 1 )
    end
  end
  
  private
    
    def delete_pdf_file
      File.delete( self.path )  if File.exists?( self.path )
    end
end
