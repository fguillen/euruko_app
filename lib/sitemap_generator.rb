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
      xml.url do
        xml.loc "#{host}/people"
        xml.lastmod User.ordered.activated.public_profile.first(:order => 'updated_at desc').updated_at.to_date
      end
      
      xml.comment! 'people:all:each'
      User.ordered.activated.public_profile.each do |user|
        xml.url do
          xml.loc "#{host}/people/#{user.to_param}"
          xml.lastmod user.updated_at.to_date
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