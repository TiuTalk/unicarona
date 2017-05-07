FactoryGirl.define do
  factory :route do
    user
    origin { FFaker::Address.street_address }
    destination { FFaker::Address.street_address }
    weekdays %i(monday sunday)
    hour { 1.hour.from_now.strftime("%H:%M") }
    enabled true
    origin_latitude { FFaker::Geolocation.lat }
    origin_longitude { FFaker::Geolocation.lng }
    destination_latitude { FFaker::Geolocation.lat }
    destination_longitude { FFaker::Geolocation.lng }
  end
end
