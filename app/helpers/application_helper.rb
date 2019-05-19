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
    if user.avatar.attached?
      metadata = user.avatar.attachment.blob.metadata
      width, height = metadata[:width], metadata[:height]
      resize_params = (width > height) ? [size, nil] : [nil, size]
      content = image_tag(user.avatar.variant(resize_to_fill: resize_params), class: "rounded-circle")
      add_class = ""
    else
      #默认头像
      text_style = "font-size: #{size/2}px;line_height: #{size/2}px;"
      content = content_tag(:span, user.name.first.capitalize, class: "text-center text-white", style: text_style)
      add_class = " rounded-circle bg-info"
    end
    klass = "d-flex justify-content-center align-items-center" + add_class
    style = "height: #{size}px;width: #{size}px;"
    content_tag(:div, content, class: klass, style: style)
  end
end
