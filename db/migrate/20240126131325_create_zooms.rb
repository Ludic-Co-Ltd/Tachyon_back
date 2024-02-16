class CreateZooms < ActiveRecord::Migration[7.1]
  def change
    create_table :zooms do |t|
      t.string :title, limit: 255, null: false
      t.string :image_path, limit: 255, null: false
      t.text :introduction_text, limit: 255, null: false
      t.string :zoom_url
      t.integer :status, limit: 1
      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
