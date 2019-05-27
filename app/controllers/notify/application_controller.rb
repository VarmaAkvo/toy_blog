class Notify::ApplicationController < ApplicationController
  before_action :authenticate_user!
  before_action :update_last_visit_time

  def update_last_visit_time
    NotifyVisitTime.find_or_create_by(user_id: current_user.id).touch
  end
end
