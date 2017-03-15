RSpec.configure do |config|
  config.before(:suite) do
    Time.zone = ActiveSupport::TimeZone.all.sample
    puts "Randomized with timezone #{Time.zone}"
  end
end
