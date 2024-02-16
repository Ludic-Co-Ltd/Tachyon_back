class CreateSelectionStatusesTable < ActiveRecord::Migration[7.1]
  def change
    drop_table(:selection_statuses, if_exists: true)

    create_table :selection_statuses do |t|
      t.bigint :user_id, null: false
      t.bigint :company_id, null: false
      t.integer :status, null: false, limit:1
      t.datetime :selection_date, null: false
      t.integer :ranking, null: false
      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
