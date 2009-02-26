# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def title(page_title)
    content_for(:title) { page_title }
  end

  def menu_to(name, options = {}, html_options = {}, &block)
    content = link_to(name, options, html_options, &block)
    if current_page?(options)
      "<li class=\"selected\">#{content}</li>"
    else
      "<li>#{content}</li>"
    end
  end
  
  def label(object_name, method, text = nil, options = {})
    if options[:required]
      "<label for=\"#{method}\">#{text} <span class=\"required\">*</span></label>"
    else
      "<label for=\"#{method}\">#{text}</label>"
    end
  end
  
  def times_array( hour_ini = '00', hour_end = '24' )
    times = []
    (hour_ini..hour_end).each do |hh|
      ['00','10','20','30','40','50'].each do |mm|
        times << "#{hh}:#{mm}" 
      end
    end

    return times
  end

  def base_url
    request.protocol + request.host_with_port
  end
  
  # render an url or a simple text or a link
  # depending of the presence of the arguments
  def web_render( web_name, web_url )
    return link_to( web_name, web_url )   if !web_name.empty? && !web_url.empty?
    return link_to( web_url, web_url )    if web_name.empty? && !web_url.empty?
    return web_name                       if !web_name.empty? && web_url.empty?
  end
end
