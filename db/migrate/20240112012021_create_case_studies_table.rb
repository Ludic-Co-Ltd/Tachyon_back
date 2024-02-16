class CreateCaseStudiesTable < ActiveRecord::Migration[7.1]
  def change
    drop_table(:case_studies, if_exists: true)

    create_table :case_studies do |t|
      t.bigint :mentor_id, null: false
      t.bigint :company_id, null: false
      t.bigint :industry_id, null: false
      t.string :question, limit: 255, null: false
      t.longtext :content, null: false
      t.integer :thinking_time, null: false
      t.integer :is_undisclosed, null: false, limit:1
      t.integer :status, null: false, limit:1
      t.longtext :correction_result
      t.date :start_date
      t.date :end_date
      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
