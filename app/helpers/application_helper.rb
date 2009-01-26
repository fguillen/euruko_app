# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def menu_to(name, options = {}, html_options = {}, &block)
    content = link_to_unless_current(name, options, html_options, &block).to_s
    "<span>#{content}</span>"
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
end
