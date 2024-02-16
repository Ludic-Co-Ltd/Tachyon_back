class AddThumbnailFieldInEntrySheetsTable < ActiveRecord::Migration[7.1]
  def change
    add_column :entry_sheets, :thumbnail, :string, after: :file_path
  end
end
