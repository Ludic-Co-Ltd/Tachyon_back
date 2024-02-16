class CreateEventsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table(:events, if_exists: true)
    drop_table(:events_tables, if_exists: true)

    create_table :events do |t|
      t.bigint :company_id, null: false
      t.string :name, limit: 50, null: false
      t.text :overview, null: false
      t.date :event_date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.string :image_path, limit: 255, null: false
      t.string :materials_path, limit: 255, null: false
      t.integer :event_type, null: false, limit: 1
      t.string :open_chat_url, limit:255
      t.string :zoom_url, limit:255
      t.float :rating
      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
