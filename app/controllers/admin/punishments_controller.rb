class Admin::PunishmentsController < ApplicationController
  def index
    @punishments = Punishment.includes(:user).all
                             .page(params[:page]).per_page(10)
  end

  def new
    @punishment = Punishment.new(punished_name: params[:punished_name])
  end

  def create
    expire_time = params[:punishment][:expire_time]
    punished = User.find_by(name: params[:punishment][:punished_name])
    if punished.nil?
      @punishment = Punishment.new
      flash[:alert] = "不存在该用户。"
      render 'new' and return
    end
    params_hash = {user_id: punished.id, expire_time: expire_time.to_i.days.after}
    @punishment = Punishment.new(params_hash)
    if @punishment.save
      flash[:notice] = "#{punished.name}已成功封禁#{expire_time}天。"
      redirect_to admin_punishments_path
    else
      flash[:alert] = "处罚失败。"
      render 'new'
    end
  end

  def edit
    @punishment = Punishment.find(params[:id])
  end

  def update
    @punishment = Punishment.find(params[:id])
    extra_time = params[:punishment][:extra_time]

    original_exprie_time = @punishment.expire_time
    new_expire_time = original_exprie_time + extra_time.to_i.days
    punished_id = @punishment.user_id

    if @punishment.update(expire_time: new_expire_time)
      punished = User.find(punished_id)
      flash[:notice] = "#{punished.name}的处罚已延长#{extra_time}天。"
      redirect_to admin_punishments_path
    else
      flash[:alert] = '更新处罚失败'
      render 'edit'
    end
  end

  def destroy
    @punishment = Punishment.find(params[:id])
    punished = User.find(@punishment.user_id)
    @punishment.destroy
    flash[:notice] = "#{punished.name}的处罚已解除。"
    redirect_to admin_punishments_path
  end
end
