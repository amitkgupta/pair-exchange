# Selenium driven tests (where js: true) need to make real web connections.
RSpec.configure do |config|
  config.before(:each, js: true) do
    WebMock.allow_net_connect!
  end

  config.after(:each, js: true) do
    WebMock.disable_net_connect! :allow => %r{/((__.+__)|(hub/session.*))$}
  end
end