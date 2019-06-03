class User < ApplicationRecord
  validates :name, presence: true, length: {maximum: Settings.name_length}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.max_length},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.pass_min_lg}

  has_secure_password

  before_save :email_downcase

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost
    cost = if cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  private

  def email_downcase
    self.email = email.downcase
  end
end
