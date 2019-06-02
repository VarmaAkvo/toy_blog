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
    reported_id = Object.const_get(reportable_type).find(reportable_id).user_id
    reporter_id = current_user.id
    report_params = {reason: reason, reportable_id: reportable_id,
                     reportable_type: reportable_type,
                     reported_id: reported_id, reporter_id: reporter_id}
    # 同一人不能重复举报
    if Report.exists?(report_params.slice(:reportable_id, :reportable_type, :reporter_id))
      flash[:alert] = '不能重复举报。'
      redirect_to root_path and return
    end
    if @report = Report.create(report_params)
      flash[:notice] = '举报成功。'
      redirect_to root_path
    else
      flash[:alert] = '举报失败'
      render 'new'
    end
  end
end
