source 'https://rubygems.org'

gem 'rails', '3.2.6'

gem 'heroku'
gem 'haml-rails'
gem 'jquery-rails'
gem "less-rails"
gem 'twitter-bootstrap-rails'
gem 'thin'
gem 'google-api-client'
gem 'redcarpet'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'font-awesome-sass-rails'
  gem 'uglifier', '>= 1.0.3'
end

group :production do
  gem 'heroku_san'
  gem 'pg'
end

group :test do
  gem "shoulda-matchers"
  gem 'rake'
  gem 'webmock'
  gem 'database_cleaner'
  gem 'capybara'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'sqlite3'
  gem 'factory_girl'
end

group :development do
  gem 'bullet'
end
