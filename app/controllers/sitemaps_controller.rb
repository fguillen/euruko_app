class SitemapsController < ApplicationController
  def show
    render :text => SitemapGenerator.do, :layout => false, :content_type => "text/xml"
  end
end