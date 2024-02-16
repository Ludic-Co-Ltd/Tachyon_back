class CreateCompanyReviewsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table(:company_reviews, if_exists: true)

    create_table :company_reviews do |t|
      t.bigint :user_id, null: false
      t.bigint :company_id, null: false
      t.string :title, null: false
      t.text :content, null: false
      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
