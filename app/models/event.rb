class Event < ApplicationRecord
  has_many :event_reservations
  belongs_to :company
  belongs_to :mentor

  validates :company_id, presence:true
  validates :name, length: { maximum: 50 }, presence:true
  validates :overview, presence:true
  validates :event_date, presence:true
  validates :start_time, presence:true
  validates :end_time, presence:true
  validates :image_path, presence:true
  validates :materials_path, presence:true
  validates :event_type, presence:true
  validates :open_chat_url, presence:true
  validates :zoom_url, presence:true
end
