class SelectionStatus < ApplicationRecord
  belongs_to :user
  belongs_to :company

  validates :user_id, presence:true, 
  validates :company_id, presence:true 
  validates :status, presence:true
  validates :selection_date, presence:true
  validates :ranking, presence:true
end
