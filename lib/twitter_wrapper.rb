class TwitterWrapper
  def self.post( text )
    url = URI.parse( 'http://twitter.com/statuses/update.xml' )
    req = Net::HTTP::Post.new( url.path )
    req.basic_auth( APP_CONFIG[:twitter_user], APP_CONFIG[:twitter_pass] )
    req.set_form_data( { 'status'=> text }, ';' )
    res = Net::HTTP.new( url.host, url.port ).start { |http| http.request( req ) }    
    
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection  then "OK"
    else res.error!
    end
  end
end