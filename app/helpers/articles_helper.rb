module ArticlesHelper
  def is_my_blog?
    if current_user && params[:name].downcase == current_user.name
      return true
    end
    return false
  end

  def tag_list(tags, record_type)
    return nil if tags.empty?

    path = "search_#{record_type}_tags_path"
    tags.map(&:name).map do |tag|
      link_to '#' + tag, eval(path + "('#{tag}')"), class: 'small px-2'
    end.join.html_safe.yield_self do |tags|
      content_tag(:div, tags, class: "text-break")
    end
  end

  def user_tag_list(tags)
    tag_list(tags, 'user')
  end

  def article_tag_list(tags)
    tag_list(tags, 'article')
  end

  def tag_list_with_count(uats)
    return nil if uats.empty?
    uats.map do |u|
      [u.tag.name, u.total]
    end.map do |tag, total|
      link_to "##{tag}(#{total})", blog_tag_search_path(@owner.name, tag), class: 'small text-break d-inline-block mx-2'
    end.join.html_safe.yield_self do |tags|
      content_tag(:div, tags, class: "text-wrap")
    end
  end
end
