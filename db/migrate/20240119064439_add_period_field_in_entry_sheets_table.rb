class AddPeriodFieldInEntrySheetsTable < ActiveRecord::Migration[7.1]
  def change
    # add_column :entry_sheets, :period, :date, after: :company_id
  end
end
