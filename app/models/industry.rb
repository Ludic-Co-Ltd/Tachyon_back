class Industry < ApplicationRecord
  has_many :companies
  has_many :case_studies
  has_many :users
  
  validates :name, length: { maximum: 50 }, presence:true
end
