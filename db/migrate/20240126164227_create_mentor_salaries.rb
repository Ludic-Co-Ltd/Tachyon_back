class CreateMentorSalaries < ActiveRecord::Migration[7.1]
  def change
    create_table :mentor_salaries do |t|
      t.bigint :mentor_id, null: false
      t.integer :salary, null: false
      t.integer :year, null: false
      t.integer :month, null: false
      t.timestamps
      t.timestamp :deleted_at
    end

    add_foreign_key :mentor_salaries, :mentors
  end
end
