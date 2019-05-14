module ApplicationHelper
  def error_list(model, attribute)
    return nil if model.errors[attribute].empty?
    related_msgs = model.errors.full_messages.select {|msg| msg.include? attribute.capitalize.to_s }
    items = related_msgs.map do |msg|
              content_tag(:small, msg)
            end.join.html_safe
    list = content_tag(:div, items, class: "alert alert-danger mt-2")
  end
end
