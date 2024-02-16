class DropJobCategoriesTable < ActiveRecord::Migration[7.1]
  def change
    drop_table(:job_categories, if_exists: true)
  end
end
