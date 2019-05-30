class BlogPunishmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @blog_punishments = BlogPunishment.includes(:punished).where(punisher_id: current_user.id)
  end

  def new
    @blog_punishment = BlogPunishment.new
  end

  def create
    expire_time = params[:blog_punishment][:expire_time]
    punished = User.find_by(name: params[:blog_punishment][:punished_name])
    if punished.nil?
      flash[:alert] = "不存在该用户。"
      render 'new' and return
    end
    params_hash = {punisher_id: current_user.id, punished_id: punished.id, expire_time: expire_time.to_i.days.after}
    @blog_punishment = BlogPunishment.new(params_hash)
    if @blog_punishment.save
      flash[:notice] = "#{punished.name}已成功封禁#{expire_time}天。"
      redirect_to blog_punishments_path
    else
      flash[:alert] = "处罚失败。"
      render 'new'
    end
  end

  def edit
    @blog_punishment = BlogPunishment.find(params[:id])
  end

  def update
    @blog_punishment = BlogPunishment.find(params[:id])
    extra_time = params[:blog_punishment][:extra_time]

    original_exprie_time = @blog_punishment.expire_time
    new_expire_time = original_exprie_time + extra_time.to_i.days
    punished_id = @blog_punishment.punished_id

    if @blog_punishment.update(expire_time: new_expire_time)
      punished = User.find(punished_id)
      flash[:notice] = "#{punished.name}的处罚已延长#{extra_time}天。"
      redirect_to blog_punishments_path
    else
      flash[:alert] = '更新处罚失败'
      render 'edit'
    end
  end

  def destroy
    @blog_punishment = BlogPunishment.find(params[:id])
    punished = User.find(@blog_punishment.punished_id)
    @blog_punishment.destroy
    flash[:notice] = "#{punished.name}的处罚已解除。"
    redirect_to blog_punishments_path
  end
end
