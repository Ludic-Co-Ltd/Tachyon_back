class EventReservation < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user_id, presence:true
  validates :event_id, presence:true
  validates :status, presence:true
  validates :fixed_date, presence:true
end
