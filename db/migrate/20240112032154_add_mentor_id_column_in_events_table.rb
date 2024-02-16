class AddMentorIdColumnInEventsTable < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :mentor_id, :bigint, after: :company_id
    add_foreign_key :events, :mentors
  end
end
