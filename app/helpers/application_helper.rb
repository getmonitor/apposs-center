module ApplicationHelper
  def err resource
    resource.errors.to_a.each{|msg| content_tag :li, msg}.join "\n"
  end
end
