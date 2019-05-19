module ApplicationHelper
  def error_list(model, attribute)
    return nil if model.errors[attribute].empty?
    related_msgs = model.errors.full_messages.select {|msg| msg.include? attribute.capitalize.to_s }
    items = related_msgs.map do |msg|
              content_tag(:small, msg)
            end.join.html_safe
    list = content_tag(:div, items, class: "alert alert-danger mt-2")
  end

  def avatar_of(user, size)
    #默认头像
    style = "height: #{size}px;width: #{size}px;"
    text_style = "font-size: #{size/2}px;line_height: #{size/2}px;"
    name = content_tag(:span, user.name.first.capitalize, class: "text-center text-white", style: text_style)
    content_tag(:div, name, class: "rounded-circle bg-info d-flex justify-content-center align-items-center", style: style)
  end
end
