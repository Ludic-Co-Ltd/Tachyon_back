class User < ApplicationRecord
  has_secure_password
  has_many :user_tickets
  has_many :entry_sheets
  has_many :case_study_comments
  has_many :interview_reservations
  has_many :event_reservations
  has_many :selection_statuses
  has_many :interview_experiences
  has_many :company_reviews
  belongs_to :mentor
  belongs_to :industry, class_name: 'Industry', foreign_key: 'industry_id_1'
  belongs_to :industry, class_name: 'Industry', foreign_key: 'industry_id_2'

  validates :mentor_id, presence:true
  validates :email, length: { maximum: 255 }, presence: true,  format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness:true
  # validates :password, presence: true, length: { in: 8..32 }, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+\z/ }
  validates :first_name, length: { maximum: 50 }, presence:true
  validates :last_name, length: { maximum: 50 }, presence:true
  validates :birth_date, presence:true
  validates :gender, presence:true
  validates :status, presence:true

  def full_name
    last_name + ' ' + first_name
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
