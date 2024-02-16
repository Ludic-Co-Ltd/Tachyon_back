class PurchaseHistory < ApplicationRecord
  belongs_to :user
  
  validates :user_id, presence:true
  validates :price, presence:true
  validates :name, length: { maximum: 50 }, presence: true
end
