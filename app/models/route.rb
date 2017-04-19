class Route < ApplicationRecord
  # Associations
  belongs_to :user, inverse_of: :routes

  # Validations
  validates :origin, :destination, :origin_latitude, :origin_longitude, :destination_latitude, :destination_longitude, presence: true

  # Callbacks
  before_validation :geocode_origin, :geocode_destination

  private

  def geocode_origin
    return unless origin.present?

    # TODO: Replace this with the geocoder gem
    self.origin_latitude = rand(1.0..2.0)
    self.origin_longitude = rand(1.0..2.0)
  end

  def geocode_destination
    return unless destination.present?

    # TODO: Replace this with the geocoder gem
    self.destination_latitude = rand(1.0..2.0)
    self.destination_longitude = rand(1.0..2.0)
  end
end
