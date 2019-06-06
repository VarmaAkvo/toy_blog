module ArticlesHelper
  def is_my_blog?
    if current_user && params[:name].downcase == current_user.name
      return true
    end
    return false
  end

  def tag_list(tags, record_type)
    return nil if !tags.present?

    path = "search_#{record_type}_tags_path"
    tags.map(&:name).map do |tag|
      link_to '#' + tag, eval(path + "('#{tag}')"), class: 'small px-2'
    end.join.html_safe.yield_self do |tags|
      content_tag(:div, tags, class: "text-break")
    end
  end
  #接受[tag_name, search_path]来生成对应的链接
  def new_tag_list(array)
    array.map do |tag, path|
      link_to tag, path, class: 'small px-2'
    end.join.html_safe.yield_self do |tags|
      content_tag(:div, tags, class: "text-break")
    end
  end

  def user_tag_list(tag_list)
    return nil if tag_list.blank?
    params = tag_list.split.map do |tag|
      ['#' + tag, search_user_tags_path(tag)]
    end
    new_tag_list(params)
    # tag_list(tags, 'user')
  end

  def article_tag_list(tag_list)
    return nil if tag_list.blank?
    params = tag_list.split.map do |tag|
      ['#' + tag, search_article_tags_path(tag)]
    end
    new_tag_list(params)
  end

  def tag_list_with_count(uats)
    return nil unless uats.present?
    uats.map do |u|
      [u.tag.name, u.total]
    end.map do |tag, total|
      link_to "##{tag}(#{total})", blog_tag_search_path(@owner.name, tag), class: 'small text-break d-inline-block mx-2'
    end.join.html_safe.yield_self do |tags|
      content_tag(:div, tags, class: "text-wrap")
    end
  end

  def report_link(type, id, css)
    path = new_report_path(report: {reportable_id: id, reportable_type: type})
    link_to('举报', path, class: css, role: 'button' )
  end
end
