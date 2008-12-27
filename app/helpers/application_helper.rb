# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def menu(name, options = {}, html_options = {}, &block)
    name = "<span>" + name + "</span>"
    content = link_to(name, options, html_options, &block).to_s
    if current_page?(options)
      "<li class=\"current\">#{content}</li>"
    else
      "<li>#{content}</li>"
    end
  end
  
  def admin?
    current_user && current_user.admin?
  end
end
