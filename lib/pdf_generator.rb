class PDFGenerator
  def self.users_list( users, current_user )
    pdf = PDF::Writer.new
    users.each_with_index do |user,index|
      out = "#{"%03d" % index}, #{"%03d" % user.id}, #{user.name}"
      out += ", #{user.email}"  if current_user && current_user.admin?
      out += "\n"
      pdf.text out
    end
    pdf.render
  end
  
  def self.create_pdf_invoice( invoice )
    pdf = PDF::Writer.new(:paper => "A4")
    pdf.margins_pt(36, 54)
    pdf.select_font( "Times-Roman" )
    
    pdf.image( "#{RAILS_ROOT}/public/images/invoice_header.jpg" )
    
    # pdf.add_text_wrap( 100, pdf.y, 150, "#{APP_CONFIG[:seller_invoice_info]}", 14, :right )
    pdf.text( APP_CONFIG[:seller_invoice_info], :font_size => 14, :left => 210, :justification => :left )
    
    pdf.move_pointer( 50 )
    pdf.text( "Invoice Number: <b>#{APP_CONFIG[:invoices_serial_prefix]}#{invoice.serial}</b>" )
    pdf.text( "Date: <b>#{invoice.date.strftime( '%d of %b of %Y' )}</b>" )
    pdf.text( "To:", :top => 1000 )
    
    if invoice.cart.user.invoice_info
      invoice.cart.user.invoice_info.each_line do |line|
        pdf.text( "#{line}" )
      end
    end

    #
    # TABLE
    # 
    pdf.move_pointer( 50 )
    table_elements = PDF::SimpleTable.new     
    table_elements.data = []
    invoice.cart.events.each do |event|
      table_elements.data << { "concept" => event.name, "price" => "#{Utils.cents_to_euros(Utils.total_without_tax(event.price_cents))} \x80" }
    end
    
    if invoice.cart.events.empty?
      table_elements.data << { "concept" => "", "price" => "0€" }
    end
    
    table_elements.column_order = [ "concept", "price" ]
    
    table_elements.columns["concept"] = 
      PDF::SimpleTable::Column.new("concept") { |col| 
        col.heading = "Concept" 
        col.justification = :left
        col.width = 350
      }
      
    table_elements.columns["price"] = 
      PDF::SimpleTable::Column.new("price") { |col| 
        col.heading = "Price" 
        col.justification = :right
        col.width = 100
      }
    
    table_elements.font_size     = 20
    table_elements.position      = 90 
    table_elements.orientation   = :right 
    # table_elements.width         = 550
    table_elements.render_on( pdf )
    
    table_totals = PDF::SimpleTable.new
    table_totals.data = [
      { "concept" => "Total", "price" => "#{Utils.cents_to_euros(Utils.total_without_tax(invoice.cart.total_price))} \x80" },
      { "concept" => "Tax #{APP_CONFIG[:tax_percent]}%", "price" => "#{Utils.cents_to_euros(Utils.total_tax(invoice.cart.total_price))} \x80" },
      { "concept" => "<b>Total + Tax</b>", "price" => "#{Utils.cents_to_euros( invoice.cart.total_price )} \x80" }
    ]
    table_totals.column_order = [ "concept", "price" ]
    
    table_totals.columns["concept"] = 
      PDF::SimpleTable::Column.new("concept") { |col| 
        col.heading = "Concept" 
        col.justification = :right
        col.width = 350
      }
      
    table_totals.columns["price"] = 
      PDF::SimpleTable::Column.new("price") { |col| 
        col.heading = "Price" 
        col.justification = :right
        col.width = 100
      }
    
    table_totals.font_size     = 20
    table_totals.show_headings = false
    table_totals.position      = 90 
    table_totals.orientation   = :right 
    # table_totals.width         = 550
    table_totals.render_on( pdf )
    
    FileUtils.mkdir_p( File.dirname( invoice.path ) )
    File.open( invoice.path, 'w' ) { |f| f.write( pdf.render ) }
    
    # puts "XXX: printed invoice on: #{invoice.path}"
  end
end