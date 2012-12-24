# Selenium driven tests (where js: true) don't work with the transactional database
# cleaning strategy.  Also, the request specs which use Selenium need to make real web
# connections.
RSpec.configure do |config|
  config.before(:each) do
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
      WebMock.allow_net_connect!
    else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
  end

  config.after(:each) do
    WebMock.disable_net_connect! :allow => %r{/((__.+__)|(hub/session.*))$}
    DatabaseCleaner.clean
  end
end