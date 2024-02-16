class JobCategory < ApplicationRecord
  has_many :case_studies
  has_many :interview_experiencess
  belongs_to :company

  validates :company_id, presence:true
  validates :name, length: { maximum: 50 }, presence:true
end
