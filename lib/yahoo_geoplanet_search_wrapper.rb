class YahooGeoplanetSearchWrapper
  LOCALE      = "us"
  API_VERSION = "v1"
  API_URL     = "http://where.yahooapis.com/v1/"
  
  def self.search( query, yahoo_id )
    query = URI.encode(query.gsub(/\s+/, '+'))
    url = URI.join( "#{API_URL}/#{API_VERSION}", "places$and(.q('#{query}'),.type('Town'));start=0;count=10")
    url.query = "lang=#{LOCALE}&appid=#{yahoo_id}"

    res = YahooGeoplanetSearchWrapper.send_search( url )
    document = REXML::Document.new( res )

    places = []
    
    document.elements.each("places/place") do |place|
      places << {
        :name => place.text('name'),
        :admin1 => place.text('admin1'),
        :admin2 => place.text('admin2'),
        :pc => place.text('postal'),
        :country => place.text('country')
      }
      # puts "XXXXXXX"
      # puts place
      # puts "-------"
      # puts "type:#{place.text('placeTypeName')}"
      # puts "admin1:#{place.text('admin1')}"
      # puts "admin2:#{place.text('admin2')}"
      # puts "name:#{place.text('name')}"
      # # <postal type='Zip Code'
      # puts "PC:#{place.text('postal')}"
      # puts "country:#{place.text('country')}"
    end
    
    return places
  end
  
  def self.send_search( url )
    req = Net::HTTP::Get.new(url.request_uri)
    http = Net::HTTP.new(url.host, url.port)
    http.read_timeout = 1
    res = http.start() { |conn| conn.request(req) }
    
    return res.body
  end
  
  def self.place_to_s( place )
    place_s = "#{place[:name]}, "
    # place_s << "#{place[:pc]}, "  unless place[:pc].blank?
    place_s << "#{place[:admin2]}, "
    place_s << "#{place[:admin1]}, "
    place_s << "#{place[:country]}"

    return place_s
  end
end