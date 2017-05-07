source 'https://rubygems.org'
ruby '2.4.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.0'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'

# Assets
gem 'sass-rails', '~> 5.0.6'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks', '~> 5'
gem 'font-awesome-rails', '~> 4.7'

# Models
gem 'phonelib', '~> 0.6'
gem 'simple_form', github: 'elsurudo/simple_form', branch: 'rails-5.1.0'
gem 'clearance', '~> 1.16'
gem 'geocoder', '~> 1.4'

# Clients
gem 'twilio-ruby', '~> 4.13'

group :development, :test do
  gem 'pry-rails', '~> 0.3'
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails', '~> 4.8'
  gem 'ffaker', '~> 2.5'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec', '~> 1.0'
end

group :test do
  gem 'simplecov', '~> 0.13', require: false
  gem 'shoulda-matchers', '~> 3.1'
  gem 'capybara', '~> 2.13'
  gem 'vcr', '~> 3.0'
  gem 'webmock', '~> 3.0'
  gem 'rails-controller-testing', '~> 1.0'
end
