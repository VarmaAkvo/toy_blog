class CorrectNotifyVisitTableName < ActiveRecord::Migration[6.0]
  def change
    rename_table :activities_notify_visit, :activity_notify_visits
    rename_table :comments_notify_visit, :comment_notify_visits
    rename_table :replies_notify_visit, :reply_notify_visits
  end
end
