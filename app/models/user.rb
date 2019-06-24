class User < ApplicationRecord
  attr_accessor :remember_token
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
                                  foreign_key: :follower_id,
                                  dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
                                   foreign_key: :followed_id,
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  validates :name, presence: true, length: {maximum: Settings.name_length}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.max_length},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.pass_min_lg},
             allow_nil: true

  has_secure_password

  before_save :email_downcase

  def forget
    update_column :remember_digest, nil
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_digest)
  end

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost
    cost = if cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

    def authenticated? remember_token
      return unless remember_digest.nil?
      BCrypt::Password.new remember_digest.is_password? remember_token
    end
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  private

  def email_downcase
    self.email = email.downcase
  end
end
