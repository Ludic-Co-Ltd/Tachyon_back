class AddForeignKeys < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :users, :mentors
    add_foreign_key :user_tickets, :users
    add_foreign_key :companies, :industries
    add_foreign_key :events, :companies
    add_foreign_key :entry_sheets, :users
    add_foreign_key :entry_sheets, :companies
    add_foreign_key :case_studies, :mentors
    add_foreign_key :case_studies, :companies
    add_foreign_key :case_studies, :industries
    add_foreign_key :case_study_comments, :case_studies
    add_foreign_key :case_study_comments, :users
    add_foreign_key :interview_reservations, :users
    add_foreign_key :interview_reservations, :mentors
    add_foreign_key :event_reservations, :users
    add_foreign_key :event_reservations, :events
    add_foreign_key :selection_statuses, :users
    add_foreign_key :selection_statuses, :companies
    add_foreign_key :interview_experiences, :users
    add_foreign_key :interview_experiences, :companies
    
    change_column :case_study_comments, :comment, :text
  end
end
