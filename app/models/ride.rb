class Ride < ApplicationRecord
  # Associations
  belongs_to :driver, class_name: 'User', inverse_of: :rides_given
  belongs_to :passenger, class_name: 'User', inverse_of: :rides_taken
  belongs_to :route, inverse_of: :rides

  # Validations
  validates :driver, :passenger, :route, presence: true

  # Temporary attributes
  attr_accessor :origin, :destination
end
