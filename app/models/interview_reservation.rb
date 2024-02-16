class InterviewReservation < ApplicationRecord
  belongs_to :user
  belongs_to :mentor

  validates :user_id, presence:true
  validates :mentor_id, presence:true
  validates :category, presence: true
  validates :status, presence:true
  validates :interview_date, presence:true
end
