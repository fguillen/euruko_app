namespace :sitemap do
  desc "Craete and return the sitemap.xml"
  task :do => :environment do
    puts SitemapGenerator.do
  end
end