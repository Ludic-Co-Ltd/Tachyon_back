class AddZoomUrlFieldInInterviewReservationsTable < ActiveRecord::Migration[7.1]
  def change
    add_column :interview_reservations, :zoom_url, :string, after: :status
  end
end
