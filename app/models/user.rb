class User < ApplicationRecord
  include Clearance::User

  # Validations
  validates :name, :email, presence: true
  validates :password, length: { minimum: 8 }, confirmation: true, on: :create
  validates :phone, phone: { types: [:mobile], allow_blank: true }

  # Callbacks
  before_validation :normalize_phone

  private

  def normalize_phone
    self.phone = Phonelib.parse(phone).national(false)
  end
end
