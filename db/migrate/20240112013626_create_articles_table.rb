class CreateArticlesTable < ActiveRecord::Migration[7.1]
  def change    
    drop_table(:articles, if_exists: true)

    create_table :articles do |t|
      t.string :title, limit: 255, null: false
      t.string :image_path, limit: 255, null: false
      t.string :introduction_text, limit: 255, null: false
      t.text :content1
      t.text :content2
      t.string :subtitle, limit: 255
      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
