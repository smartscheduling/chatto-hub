source 'https://rubygems.org'
ruby '2.1.5'

gem 'rails', '4.2.1'
gem 'pg'
gem 'virtus'

# Authentication
gem 'omniauth-github'
gem 'devise'
gem 'dotenv-rails'
gem 'slack-api'
gem 'rest-client'

# Assets
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'sass-rails', '~> 5.0'
gem 'font-awesome-rails'
gem 'foundation-rails'
gem 'bourbon'
gem 'neat'
gem 'refills'

group :test do
  gem 'webmock'
  gem 'vcr'
  gem 'coveralls', require: false
  gem 'email_spec'
end

group :development, :test do
  gem 'pry-rails'
  gem 'spring'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'launchy'
  gem 'factory_girl'
  gem 'valid_attribute'
  gem 'shoulda-matchers', require: false
  gem 'quiet_assets'
end

group :production do
  gem 'rails_12factor'
end

