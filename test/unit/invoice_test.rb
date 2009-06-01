require File.dirname(__FILE__) + '/../test_helper'

class InvoiceTest < ActiveSupport::TestCase
  def test_get_next_serial
    assert_equal( "001", Invoice.get_next_serial )
    new_invoice = Factory(:invoice)
    
    assert_equal( new_invoice.serial.to_i + 1, Invoice.get_next_serial.to_i )
  end
  
  def test_print_with_car_without_events
    cart = Factory(:cart)
    
    invoice = Invoice.print( cart )
    
    assert( File.exists?( invoice.path ) )
    assert_equal( cart, invoice.cart )
    assert_not_nil( invoice.date )
  end
  
  def test_print_with_car_with_events
    cart = Factory(:cart)
    cart.update_attribute( :invoice_info, "My Compaty\nMy street" )
    
    4.times do 
      cart.events << Factory(:event)
    end
    
    invoice = Invoice.print( cart )
    
    assert( File.exists?( invoice.path ) )
    assert_equal( cart, invoice.cart )
    assert_not_nil( invoice.date )
  end
  
  def test_bug_on_the_third_invoice
    cart = Factory(:cart)
    
    assert_difference "Invoice.count", 1 do
      Invoice.print( cart )
    end
    
    cart = Factory(:cart)
    
    assert_difference "Invoice.count", 1 do
      Invoice.print( cart )
    end
    
    cart = Factory(:cart)
    
    assert_difference "Invoice.count", 1 do
      Invoice.print( cart )
    end
  end
  
  # def test_threads
  #   
  #   100.times do
  #     Thread.new do
  #       cart = Factory(:cart)
  #       invoice = Invoice.print( cart )
  #     end
  #   end
  #   sleep( 10000 )
  # end
  
  def test_url_path
    invoice = Factory(:invoice)
    invoice.path = "#{RAILS_ROOT}//public/invoices/myinvoice.pdf"
    
    assert_equal( "/invoices/myinvoice.pdf", invoice.url_path )
  end
  
  def test_on_destroy_delete_pdf_file
    cart = Factory(:cart)
    invoice = Invoice.print( cart )
    
    assert( File.exists?( invoice.path ) )
    
    invoice.destroy
    
    assert( !File.exists?( invoice.path ) )
  end
end