require File.dirname(__FILE__) + '/../test_helper'


class PDFGeneratorTest < ActiveSupport::TestCase
  def setup
  end
  
  def test_create_invoice
    cart = Factory(:cart)
    cart.user.update_attribute( :invoice_info, "My Compaty\nMy street\n123456798H" )
    
    4.times do 
      cart.events << Factory(:event)
    end
    
    invoice = Factory( :invoice, :cart => cart )

    PDFGenerator.create_pdf_invoice( invoice )
    
    assert( File.exists?( invoice.path ) )
  end
end