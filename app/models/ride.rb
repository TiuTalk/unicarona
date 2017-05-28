class Ride < ApplicationRecord
  include AASM

  # Associations
  belongs_to :driver, class_name: 'User', inverse_of: :rides_given
  belongs_to :passenger, class_name: 'User', inverse_of: :rides_taken
  belongs_to :route, inverse_of: :rides

  # Validations
  validates :driver, :passenger, :route, presence: true

  # Callbacks
  before_validation :set_driver

  # State machine
  aasm(column: :status) do
    state :pending, initial: true
    state :accepted
    state :rejected
    state :completed
    state :canceled

    event :accept do
      transitions from: :pending, to: :accepted
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end

    event :complete do
      transitions from: :accepted, to: :completed
    end

    event :cancel do
      transitions from: [:pending, :accepted], to: :canceled
    end
  end

  def notify_driver
    data = { title: 'Pedido de carona', text: "#{passenger.first_name} pediu carona para #{route.destination}" }
    driver.notify(data)
  end

  private

  def set_driver
    self.driver = route.user if route.present?
  end
end
