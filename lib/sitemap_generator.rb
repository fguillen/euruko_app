class SitemapGenerator
  def self.do
    host = "http://#{APP_CONFIG[:site_domain]}"
    result = ""
    
    xml = Builder::XmlMarkup.new( :target => result, :indent => 2 )
    xml.instruct!
    xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
      
      xml.comment! 'root'
      xml.url do
        xml.loc host
        xml.lastmod Paper.visible.first(:order => 'updated_at desc').updated_at.to_date
      end
      
      xml.comment! 'calendar'
      xml.url do
        xml.loc "#{host}/calendar"
        xml.lastmod Paper.visible.first(:order => 'updated_at desc').updated_at.to_date
      end
      
      xml.comment! 'talks'
      xml.comment! 'talks:index'
      xml.url do
        xml.loc "#{host}/talks"
        xml.lastmod Paper.visible.first(:order => 'updated_at desc').updated_at.to_date
      end
      
      xml.comment! 'talks:each'
      Paper.visible.not_break.date_ordered.each do |paper|
        xml.url do
          xml.loc "#{host}/talks/#{paper.to_param}"
          xml.lastmod paper.updated_at.to_date
        end
      end
      
      xml.comment! 'people'
      xml.comment! 'people:all'
      xml.comment! 'people:all:index'
      (1..((User.ordered.activated.public_profile.count/User.per_page.to_f).ceil)).each do |page|
        xml.url do
          xml.loc "#{host}/people?page=#{page}"
          xml.lastmod User.ordered.activated.public_profile.first(:order => 'updated_at desc').updated_at.to_date
        end
      end
      
      xml.comment! 'people:all:each'
      User.ordered.activated.public_profile.each do |user|
        xml.url do
          xml.loc "#{host}/people/#{user.to_param}"
          xml.lastmod user.updated_at.to_date
        end
      end
      
      xml.comment! 'people:attendees'
      xml.comment! 'people:attendees:index'
      if Event.count > 0
        (1..((User.ordered.public_profile.has_paid( 1 ).count/User.per_page.to_f).ceil)).each do |page|
          xml.url do
            xml.loc "#{host}/people?event_id=1&page=#{page}&search=event_attendees"
            xml.lastmod User.ordered.public_profile.has_paid( 1 ).first(:order => 'updated_at desc').updated_at.to_date
          end
        end
      end
      
      xml.comment! 'people:speakers'
      xml.comment! 'people:speakers:index'
      (1..((User.ordered.public_speaker.count/User.per_page.to_f).ceil)).each do |page|
        xml.url do
          xml.loc "#{host}/people?page=#{page}&search=speakers"
          xml.lastmod User.ordered.public_speaker.first(:order => 'updated_at desc').updated_at.to_date
        end
      end
      
      
      xml.comment! 'static_pages'
      StaticPage.all.each do |static_page|      
        xml.url do
          xml.loc "#{host}/static_pages/#{static_page.permalink}"
          xml.lastmod static_page.updated_at.to_date
        end
      end
    end
    
    
    return result
  end
end