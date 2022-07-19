class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  before_save :downcase_email
  before_create :create_activation_digest

  # attr_accessor: tham số sẽ không lưu vào trong db
  attr_accessor :remember_token, :activation_token, :reset_token

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

  # authenticated? ~ method's name
  def authenticated? attribute, remember_token
    #binding.pry
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? remember_token
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    # field trong db?
    # binding.pry
    reset_sent_at < 2.hours.ago
  end

  private

  def downcase_email
    email.downcase! #ở đây email ~ self.email(validates)
  end

  def create_activation_digest
    # binding.pry
    self.activation_token = User.new_token
    # save in db
    self.activation_digest = User.digest activation_token
  end
end
