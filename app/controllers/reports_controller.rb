class ReportsController < ApplicationController
  before_action :authenticate_user!
  def new
    reportable_type = params[:report][:reportable_type]
    reportable_id   = params[:report][:reportable_id]
    @report = Report.new(reportable_id: reportable_id, reportable_type: reportable_type)
    @reportable = Object.const_get(reportable_type).find(reportable_id)
  end

  def create
    reason = params[:report][:reason]
    reportable_type = params[:report][:reportable_type]
    reportable_id   = params[:report][:reportable_id]
    reportable = Object.const_get(reportable_type).find(reportable_id)
    reported_id = reportable.user_id
    reporter_id = current_user.id
    report_params = {reason: reason, reportable_id: reportable_id,
                     reportable_type: reportable_type,
                     reported_id: reported_id, reporter_id: reporter_id}
    # # 同一个reportable，如果用户之前的举报还没处理则不能重复举报
    if Report.has_not_processed.exists?(report_params.slice(:reportable_id, :reportable_type, :reporter_id))
      flash[:alert] = '不能重复举报。'
      redirect_to redirect_link(reportable_type, reportable) and return
    end
    if @report = Report.create(report_params)
      flash[:notice] = '举报成功。'
      redirect_to redirect_link(reportable_type, reportable)
    else
      flash[:alert] = '举报失败'
      render 'new'
    end
  end

  private

  def redirect_link(reportable_type, reportable)
    case reportable_type
    when 'Article'
      link = root_path
    when 'Comment'
      link = user_article_path(reportable.article.user.name, reportable.article_id)
    when 'Reply'
      link = user_article_path(reportable.comment.article.user.name, reportable.comment.article_id)
    end
  end
end
