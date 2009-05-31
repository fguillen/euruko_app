CONVERTER = Iconv.new( 'ISO-8859-15//IGNORE//TRANSLIT', 'utf-8')  
  
module PDF  
  class Writer  
    alias_method :old_text, :text  
    def text(textto, options = {})  
      old_text(CONVERTER.iconv(textto), options)  
    end  
  end  
end