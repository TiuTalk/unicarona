FactoryGirl.define do
  factory :user do
    name { FFaker::NameBR.name }
    email { FFaker::Internet.email(name) }
    password { SecureRandom.hex(5) }
    phone { "219#{'%08d' % rand(8**8)}" } # Random valid number
    phone_confirmed true
  end
end
