class Route < ApplicationRecord
  # Associations
  belongs_to :user, inverse_of: :routes
  has_many :rides, inverse_of: :route

  # Scopes
  scope :enabled, -> { where(enabled: true) }

  # Validations
  validates :origin, :destination, :hour, :weekdays, :origin_latitude, :origin_longitude, :destination_latitude, :destination_longitude, presence: true

  # Callbacks
  before_validation :geocode_origin, :geocode_destination

  # Serialization
  serialize :weekdays, Array

  def distance
    Geocoder::Calculations.distance_between(origin_coordinates, destination_coordinates).round(2)
  end

  private

  def origin_coordinates
    [origin_latitude, origin_longitude]
  end

  def destination_coordinates
    [destination_latitude, destination_longitude]
  end

  def geocode_origin
    return unless origin.present? && origin_changed? && origin_latitude.blank?

    lat, lon = Geocoder.coordinates(origin + ' - RJ, Brasil')

    self.origin_latitude = lat
    self.origin_longitude = lon
  end

  def geocode_destination
    return unless destination.present? && destination_changed? && destination_latitude.blank?

    lat, lon = Geocoder.coordinates(destination + ' - RJ, Brasil')

    self.destination_latitude = lat
    self.destination_longitude = lon
  end
end
