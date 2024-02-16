class MentorSalary < ApplicationRecord
    belongs_to :mentor
  
    validates :mentor_id, presence:true
    validates :salary, presence:true
    validates :year, presence:true
    validates :month, presence:true
end
