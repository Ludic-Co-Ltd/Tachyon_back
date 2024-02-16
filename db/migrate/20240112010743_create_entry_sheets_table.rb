class CreateEntrySheetsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table(:entry_sheets, if_exists: true)

    create_table :entry_sheets do |t|
      t.bigint :user_id, null: false
      t.bigint :company_id, null: false
      t.longtext :content, null: false
      t.integer :status, null: false, limit: 1
      t.longtext :correction_result
      t.string :file_path
      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
