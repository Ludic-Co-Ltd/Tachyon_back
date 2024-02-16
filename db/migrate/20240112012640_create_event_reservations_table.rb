class CreateEventReservationsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table(:event_reservations, if_exists: true)

    create_table :event_reservations do |t|
      t.bigint :user_id, null: false
      t.bigint :event_id, null: false
      t.integer :status, null: false, limit:1
      t.datetime :fixed_date
      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
