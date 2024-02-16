class UserDetail < ApplicationRecord
  belongs_to :user

  validates :user_id, presence:true
  validates :university, length: { maximum: 50 }, presence:true
  validates :faculty, length: { maximum: 50 }, presence:true
  validates :department, length: { maximum: 50 }, presence:true
  validates :graduation_year, presence:true
  validates :first_wish_industry, length: { maximum: 50 }
  validates :second_wish_industry, length: { maximum: 50 }
end
