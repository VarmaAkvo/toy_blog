class Admin::ReportsController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "admin"
  def index
    @reports = Report.includes(:reporter, :reported).has_not_processed
                     .order(created_at: :desc).page(params[:page]).per_page(10)
  end

  def show
    @report = Report.find(params[:id])
  end

  def agree
    @report = Report.find(params[:id])
    # 同意一项举报会让其他对这reportable的举报都被标记为processed
    Report.has_not_processed
          .where(reportable_type: @report.reportable_type,
                 reportable_id: @report.reportable_id)
          .update_all(processed: true)
    @report.reportable.destroy
    flash[:notice] = '已同意一项举报。'
    redirect_to admin_reports_path
  end

  def disagree
    @report = Report.find(params[:id])
    @report.update(processed: true)
    flash[:notice] = '已反对一项举报。'
    redirect_to admin_reports_path
  end
end
