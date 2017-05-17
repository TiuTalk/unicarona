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

  # Geocoder
  geocoded_by :origin

  def length
    Geocoder::Calculations.distance_between(origin_coordinates, destination_coordinates).round(2)
  end

  def self.search(route, scope = Route)
    range = ENV.fetch('DISTANCE_RANGE', 1.5).to_f
    origin = route.origin.split(',')
    destination = route.destination.match(/\A-?[\d.]+,-?[\d\.]+\z/) ? route.destination.split(',') : route.destination

    near_origin = scope.near(origin, range * 2, unit: :km, latitude: :origin_latitude, longitude: :origin_longitude).limit(5)
    near_destination = scope.near(destination, range, unit: :km, latitude: :destination_latitude, longitude: :destination_longitude).limit(5)

    near_origin & near_destination
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

    lat, lon = Geocoder.coordinates(origin + ', Rio de Janeiro - RJ, Brasil')

    self.origin_latitude = lat
    self.origin_longitude = lon
  end

  def geocode_destination
    return unless destination.present? && destination_changed? && destination_latitude.blank?

    lat, lon = Geocoder.coordinates(destination + ', Rio de Janeiro, RJ - Brasil')

    self.destination_latitude = lat
    self.destination_longitude = lon
  end
end
