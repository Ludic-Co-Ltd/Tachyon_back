class CaseStudyComment < ApplicationRecord
  belongs_to :case_study
  belongs_to :user

  validates :case_study_id, presence:true
  validates :user_id, presence:true
  # validates :comment, presence:true
end
