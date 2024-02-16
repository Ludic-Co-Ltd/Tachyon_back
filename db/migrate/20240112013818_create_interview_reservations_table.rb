class CreateInterviewReservationsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table(:interview_reservations, if_exists: true)
    drop_table(:interview_experiences, if_exists: true)

    create_table :interview_reservations do |t|
      t.bigint :user_id, null: false
      t.bigint :mentor_id, null: false
      t.integer :category, null: false
      t.integer :status, null: false, limit: 1
      t.datetime :interview_date, null: false
      t.timestamps
      t.timestamp :deleted_at
    end

    create_table :interview_experiences do |t|
      t.bigint :user_id, null: false
      t.bigint :company_id, null: false
      t.integer :status, null: false, limit: 1
      t.text :content
      t.text :impression
      t.integer :interview_time
      t.integer :interviewer_count
      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
