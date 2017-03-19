class User < ApplicationRecord
  # Constants
  EMAIL_REGEXP = /\A[^@\s]+@[^@\s]+\z/.freeze

  # Validations
  validates :name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, on: :create
  validates :phone, phone: { types: [:mobile] }

  # Secure password
  has_secure_password

  # Callbacks
  before_validation :normalize_email, :normalize_phone

  private

  def normalize_email
    self.email = email.to_s.downcase.gsub(/\s+/, '')
  end

  def normalize_phone
    self.phone = Phonelib.parse(phone).national(false)
  end
end
