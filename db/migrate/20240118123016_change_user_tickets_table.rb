class ChangeUserTicketsTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :user_tickets, :short_interview_ticket_number, if_exists: true
    # add_column :user_tickets, :status, :integer, after: :bip_id, limit: 1, if_exists: false
    change_column_null  :user_tickets, :bip_id,  true
  end
end
