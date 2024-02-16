class CreateAdminsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table(:admins, if_exists: true)
    create_table :admins do |t|
      t.string :email, limit: 255, null: false
      t.string :password_digest, limit: 255, null: false
      t.string :user_name, limit: 255, null: false
      t.string :first_name, limit: 50
      t.string :last_name, limit: 50
      t.timestamps
      t.timestamp :deleted_at
    end
  end
end
