class Route < ApplicationRecord
  # Associations
  belongs_to :user, inverse_of: :routes

  # Validations
  validates :origin, :destination, :hour, :origin_latitude, :origin_longitude, :destination_latitude, :destination_longitude, presence: true
end
