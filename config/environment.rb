# Load the rails application
require File.expand_path('../application', __FILE__)

load(File.join(Rails.root, 'config', 'heroku_env.rb'))

# Initialize the rails application
PairExchange::Application.initialize!
