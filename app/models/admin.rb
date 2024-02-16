class Admin < ApplicationRecord
  has_secure_password
  has_many :case_study_comments
  
  validates :email, length: { maximum: 255 }, presence: true,  format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness:true
  # validates :password, presence: true, length: { in: 8..32 }, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+\z/ }
  validates :user_name, length: { maximum: 255 }, presence:true
  validates :first_name, length: { maximum: 50 }
  validates :last_name, length: { maximum: 50 }

  def Admin.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
