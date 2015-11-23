require 'bundler/setup'
require 'rspec'
require 'capybara'
require 'capybara/rspec'
require 'headless'
require 'selenium-webdriver'

# require 'capybara/poltergeist'
# require 'capybara/dsl'

APP_HOST = "https://new.databox.com"
EMAIL = 'oto@databox.com'
PASS = 'karkoli123'

Capybara.app_host = APP_HOST

Capybara.default_driver = :selenium

Capybara.server_port = 3000
Capybara.run_server = false #Whether start server when testing

Capybara.javascript_driver = :selenium
Capybara.default_max_wait_time = 60

headless = Headless.new(
  display: 99,
  autopick: true,
  reuse: false,
  # destroy_at_exit: true,
  video: {
  #  frame_rate: 12,
    codec: 'libx264'
  }
)

def set_selenium_window_size(width, height)
  window = Capybara.current_session.driver.browser.manage.window
  window.resize_to(width, height)
end

def set_selenium_window_max
  window = Capybara.current_session.driver.browser.manage.window
  window.maximize
end

RSpec.configure do |config|
  config.before :all do
    # page.driver.browser.manage.window.maximize
    # page.driver.headers = {"User-Agent" => "Mozilla/6.0"}
  end

  config.before :all do
    headless.start
  end

  config.before :each do
    set_selenium_window_size(1280, 1024) if Capybara.current_driver == :selenium
    # headless.video.start_capture
  end

  config.after :each do
    # headless.video.stop_and_save "test.mov"
  end

  config.after :all do
    headless.destroy
  end

  config.include Capybara::DSL
end
