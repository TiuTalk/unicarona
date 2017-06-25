class Ride < ApplicationRecord
  include AASM

  # Associations
  belongs_to :driver, class_name: 'User', inverse_of: :rides_given
  belongs_to :passenger, class_name: 'User', inverse_of: :rides_taken
  belongs_to :route, inverse_of: :rides

  # Scopes
  scope :ongoing, -> { where('status = ? OR (status = ? AND created_at > ?)', :pending, :accepted, 1.day.ago) }
  scope :non_pending, -> { where.not(status: :pending) }

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
      transitions from: :pending, to: :accepted, after: %i(notify_passenger)
    end

    event :reject do
      transitions from: :pending, to: :rejected, after: %i(notify_passenger)
    end

    event :complete, guards: %i(created_30min_ago?) do
      transitions from: :accepted, to: :completed, after: %i(notify_driver notify_passenger)
    end

    event :cancel do
      transitions from: [:pending, :accepted], to: :canceled, after: %i(notify_driver)
    end
  end

  def notify_driver_of_new_ride
    notify_driver(:created)
  end

  def ongoing?
    pending? || (accepted? && created_at >= 1.day.ago)
  end

  private

  def created_30min_ago?
    created_at <= 30.minutes.ago
  end

  def notify_driver(notification = nil)
    notification ||= aasm.to_state.to_sym
    notify(:driver, notification)
  end

  def notify_passenger(notification = nil)
    notification ||= aasm.to_state.to_sym
    notify(:passenger, notification)
  end

  def notify(user_type, notification)
    scope = "notification.ride.#{notification}.#{user_type}"
    params = {
      passenger: passenger.first_name,
      driver: driver.first_name,
      origin: route.origin,
      destination: route.destination,
      app: I18n.t('application.title')
    }

    notification = {
      title: I18n.t('title', { scope: scope }.merge(params)),
      text: I18n.t('text', { scope: scope }.merge(params))
    }

    user = (user_type == :driver) ? driver : passenger
    user.notify(notification)
  end

  def set_driver
    self.driver = route.user if route.present?
  end
end
