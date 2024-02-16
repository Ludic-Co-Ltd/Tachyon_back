class DropSomeTables < ActiveRecord::Migration[7.1]
  def change
    drop_table(:entry_sheet_comments, if_exists: true)
    drop_table(:entry_sheet_histories, if_exists: true)
    # drop_table(:plans, if_exists: true)
  end
end
