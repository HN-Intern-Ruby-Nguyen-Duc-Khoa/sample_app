class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  before_save :downcase_email

  validates :name, presence: true, length:
  {maximum: 10, too_long: "Tên quá dài"}

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

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
