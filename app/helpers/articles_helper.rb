module ArticlesHelper
  def is_my_blog?
    if current_user && params[:name].downcase == current_user.name
      return true
    end
    return false
  end

  def tag_list(tags)
    return nil if tags.empty?
    tags.map(&:name).map do |tag|
      link_to '#' + tag, '#', class: 'small px-2'
    end.join.html_safe.yield_self do |tags|
      content_tag(:div, tags, class: "text-break")
    end
  end

  def tag_list_with_count(uats)
    return nil if uats.empty?
    uats.map do |u|
      [u.tag.name, u.total]
    end.map do |tag, total|
      link_to "##{tag}(#{total})", '#', class: 'small text-break d-inline-block mx-2'
    end.join.html_safe.yield_self do |tags|
      content_tag(:div, tags, class: "text-wrap")
    end
  end  
end
