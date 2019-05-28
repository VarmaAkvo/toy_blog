class CreateNotify < ActiveRecord::Migration[6.0]
  def change
    # 将通知的访问时间统计分开
    create_table :activities_notify_visit do |t|
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end

    create_table :comments_notify_visit do |t|
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end

    create_table :replies_notify_visit do |t|
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end

    drop_table :notify_visit_times
  end
end
