class CreateMentorsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table(:mentors, if_exists: true)
    create_table :mentors do |t|
      t.string :email, limit: 255, null: false
      t.string :password_digest, limit: 255, null: false
      t.string :user_name, limit: 255, null: false
      t.string :first_name, limit: 50
      t.string :last_name, limit: 50
      t.date :birth_date, null: false
      t.integer :gender, null:false, limit: 1
      t.string :university, limit: 50, null: false
      t.string :faculty, limit: 50, null: false
      t.string :department, limit: 50, null: false
      t.integer :graduation_year, null: false
      t.string :job_offer_1, limit: 255
      t.string :job_offer_2, limit: 255
      t.text :self_introduction
      t.string :line_url, limit: 255, null: false
      t.string :timerex_url, limit: 255
      t.string :timerex_url_short, limit: 255
      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
