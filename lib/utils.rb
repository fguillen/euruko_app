require 'digest/sha1'

class Utils
  def self.site_key_generator
    random_array = []
    random_array << Time.now
    random_array << (1..10).map{ rand.to_s }
    Digest::SHA1.hexdigest( random_array.flatten.join('--') )
  end
  
  def self.cents_to_euros( cents )
    Kernel.sprintf( "%.2f", cents/100.0 )
  end
  
  def self.total_without_tax( cents )
    return( 
      (cents * 100).to_f / 
      (100 + APP_CONFIG[:tax_percent].to_i) 
    )
  end
  
  def self.total_tax( cents )
    return(
      (cents * APP_CONFIG[:tax_percent].to_i).to_f / 
      (100 + APP_CONFIG[:tax_percent].to_i) 
    )
  end
end