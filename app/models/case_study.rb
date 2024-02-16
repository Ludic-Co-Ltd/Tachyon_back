class CaseStudy < ApplicationRecord
  has_many :case_study_comments
  belongs_to :mentor
  belongs_to :company
  belongs_to :industry

  validates :mentor_id, presence:true
  validates :company_id, presence:true
  validates :industry_id, presence: true
  validates :question, length: { maximum: 255 }, presence:true
  validates :content, presence:true
  validates :thinking_time, presence:true
  validates :is_undisclosed, presence:true
  validates :status, presence:true
end
