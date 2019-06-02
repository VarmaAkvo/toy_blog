class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :reason, null: false
      t.boolean :processed, null: false, default: false, index: true

      t.bigint :reporter_id, null: false, index: true
      t.bigint :reported_id, null: false, index: true
      t.references :reportable, null: false, polymorphic: true, index: true

      t.timestamps
    end
  end
end
