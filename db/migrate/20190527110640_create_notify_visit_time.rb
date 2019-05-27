class CreateNotifyVisitTime < ActiveRecord::Migration[6.0]
  def change
    create_table :notify_visit_times do |t|
      t.belongs_to :user, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
