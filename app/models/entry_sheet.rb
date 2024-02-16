class EntrySheet < ApplicationRecord
  belongs_to :user
  belongs_to :company

  validates :user_id, presence:true
  validates :company_id,  presence:true
  # validates :period, presence:true
  validates :status, presence:true
end
