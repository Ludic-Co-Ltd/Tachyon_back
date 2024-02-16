class EntrySheetHistory < ApplicationRecord
  belongs_to :entry_sheet
  belongs_to :admin

  validates :entry_sheet_id, presence:true
  validates :admin_id, presence:true
  validates :comment, presence:true
end
