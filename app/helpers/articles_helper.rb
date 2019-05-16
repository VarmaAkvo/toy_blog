module ArticlesHelper
  def is_my_blog?
    if current_user && params[:name].downcase == current_user.name
      return true
    end
    return false
  end
end
