class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.models.user.valid_email_regex
  USER_PARAMS = %i(name email password password_confirmation).freeze
  before_save :downcase_email

  attr_accessor :remember_token

  scope :order_by_name, ->{order name: :desc}

  validates :name, presence: true, length:
    {
      maximum: Settings.models.user.name_length,
      too_long: I18n.t("models.user.name_too_long")
    }

  validates :email, presence: true,
    length:
    {
      minium: Settings.models.user.email_minium_length,
      maximum: Settings.models.user.email_maxinum_length,
      too_long: I18n.t("models.user.email_too_long"),
      too_short: I18n.t("models.user.email_too_short")
    },
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}

  validates :password, presence: true, length:
    {minimum: Settings.models.user.password_minium_length}, if: :password

  has_secure_password

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

    # random number
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

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
