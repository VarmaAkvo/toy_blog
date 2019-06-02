class CreatePunishments < ActiveRecord::Migration[6.0]
  def change
    create_table :punishments do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :expire_time, null: false
    end
  end
end
