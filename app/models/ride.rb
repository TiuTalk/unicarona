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
  end

  private

  def set_driver
    self.driver = route.user if route.present?
  end
end
