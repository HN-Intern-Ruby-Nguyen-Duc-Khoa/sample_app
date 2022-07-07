class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.models.user.valid_email_regex

  before_save :downcase_email

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

  private

  def downcase_email
    email.downcase!
  end
end
