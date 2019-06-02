class Admin::UsersController < Admin::ApplicationController
  def index
    @users = User.joins(:reported_records).all.group(:id)
                 .order(Arel.sql('COUNT(reports.id) DESC'))
                 .page(params[:page]).per_page(10).load
    now = Time.current
    @reported_record_count = Report.where(reported_id: @users.ids).group(:reported_id).count
    @recent_a_month_reported_count = Report.where(reported_id: @users.ids,
                                                  updated_at: 1.months.before..now)
                                           .group(:reported_id).count
    last_reports_time = Report.where(reported_id: @users.ids).group(:reported_id).maximum(:updated_at)
    @last_reports = Report.where(reported_id: last_reports_time.keys,
                                 updated_at: last_reports_time.values)
                          .map do |report|
                            [report.reported_id, report]
                          end.to_h
  end
end
