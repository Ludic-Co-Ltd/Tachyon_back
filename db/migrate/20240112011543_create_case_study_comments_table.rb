class CreateCaseStudyCommentsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table(:case_study_comments, if_exists: true)

    create_table :case_study_comments do |t|
      t.bigint :case_study_id, null: false
      t.bigint :user_id, null: false
      t.string :comment, limit: 255, null: false
      t.integer :mark1
      t.integer :mark2
      t.integer :mark3
      t.integer :mark4
      t.string :file_path
      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
