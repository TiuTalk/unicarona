class User < ApplicationRecord
  include Clearance::User

  # Associations
  has_many :routes, inverse_of: :user
  has_many :rides_given, class_name: 'Ride', foreign_key: :driver_id, inverse_of: :driver
  has_many :rides_taken, class_name: 'Ride', foreign_key: :passenger_id, inverse_of: :passenger

  # Validations
  validates :name, :email, presence: true
  validates :password, length: { minimum: 8 }, confirmation: true, on: :create
  validates :phone, phone: { types: [:mobile], allow_blank: true }

  # Callbacks
  before_validation :normalize_phone

  def confirm_phone!
    confirmation_code = SecureRandom.hex(3).upcase

    if update(phone_confirmation_code: confirmation_code)
      message = "Minha Carona: Utilize o código #{confirmation_code} para confirmar seu telefone"
      send_sms(message)
    end
  end

  def confirm_phone?(confirmation_code)
    if phone_confirmation_code === confirmation_code.upcase
      update(phone_confirmed: true, phone_confirmation_code: nil)
    else
      errors.add(:phone_confirmation_code, 'incorreto')
    end
  end

  def avatar(size: 100)
    "https://api.adorable.io/avatars/#{size}/#{email}"
  end

  def push_notification(data = {})
    return unless device_token.present?

    gcm_key = Rails.application.secrets.google_gcm_api_key
    data = { to: device_token, notification: data }

    response = RestClient.post("https://fcm.googleapis.com/fcm/send", data.to_json, Authorization: "key=#{gcm_key}", content_type: :json)
    body = JSON.parse(response.body)

    body['failure'].zero?
  end

  private

  def normalize_phone
    self.phone = Phonelib.parse(phone).national(false)
  end

  def send_sms(message)
    from = Rails.application.secrets.twilio_phone_number
    to = '+' + Phonelib.parse(phone).international(false)

    client = Twilio::REST::Client.new
    client.messages.create(from: from, to: to, body: message)
  end
end
