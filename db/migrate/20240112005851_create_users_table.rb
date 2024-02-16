class CreateUsersTable < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :user_tickets, :users, if_exists: true
    remove_foreign_key :user_details, :users, if_exists: true
    remove_foreign_key :entry_sheets, :users, if_exists: true
    remove_foreign_key :case_study_comments, :users, if_exists: true
    remove_foreign_key :interview_reservations, :users, if_exists: true
    remove_foreign_key :event_reservations, :users, if_exists: true
    remove_foreign_key :selection_statuses, :users, if_exists: true
    remove_foreign_key :interview_experiences, :users, if_exists: true
    remove_foreign_key :company_reviews, :users, if_exists: true


    drop_table(:users, if_exists: true)

    create_table :users do |t|
      t.bigint :mentor_id, null: false
      t.string :email, limit: 255, null: false
      t.string :password_digest, limit: 255, null: false
      t.string :first_name, limit: 50, null: false
      t.string :last_name, limit: 50, null: false
      t.date :birth_date, null: false
      t.integer :gender, null:false, limit: 1
      t.string :university, limit: 50, null: false
      t.string :faculty, limit: 50, null: false
      t.string :department, limit: 50, null: false
      t.integer :graduation_year, null: false
      t.bigint :industry_id_1
      t.bigint :industry_id_2
      t.integer :status, null:false, limit: 1
      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
