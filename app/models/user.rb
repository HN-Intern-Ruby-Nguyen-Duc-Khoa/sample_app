class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  before_save :downcase_email

  attr_accessor :remember_token

  validates :name, presence: true, length:
  {maximum: 100, too_long: "Tên quá dài"}

  validates :email, presence: true,
  length: {
    minium: 20,
    maximum: 255,
    too_long: "email qua dai",
    too_short: "email qua ngan"
  },
  format: {with: VALID_EMAIL_REGEX},
  uniqueness: {case_sensitive: false}

  validates :password, presence: true, length:
  {minimum: 6}, if: :password

  has_secure_password #password.present=true
  # ~ password không được nil hay false khi update hay create

  class << self
    # hash fn
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
              BCrypt::Engine::MIN_COST
            else
              BCrypt::Engine.cost
            end
      BCrypt::Password.create string, cost: cost
    end

    #random number
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  #lưu token đã được hash vào db
  def remember_me
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def forget
    update remember_digest: nil
  end

  def authenticated? remember_token
    return false unless remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  private

  def downcase_email
    email.downcase!
  end
end
