class Plan < ApplicationRecord
  has_many :users

  validates :name, length: { maximum: 50 }, presence:true
  validates :price, presence:true
  validates :es_ticket_number, presence:true
  validates :case_ticket_number, presence:true
  validates :event_ticket_number, presence:true
end
