require 'bundler/setup'
require 'rspec'
require 'capybara'
require 'capybara/rspec'
require 'headless'
require 'selenium-webdriver'
require 'pry'

DATABOX_APP_HOST = ENV['DATABOX_APP_HOST'] || "https://new.databox.com"
DATABOX_USER_EMAIL = ENV.fetch('DATABOX_USER_EMAIL')
DATABOX_USER_PASS = ENV.fetch('DATABOX_USER_PASS')

Capybara.app_host = DATABOX_APP_HOST
Capybara.default_driver = :selenium
Capybara.server_port = 3000
Capybara.run_server = false #Whether start server when testing
Capybara.javascript_driver = :selenium
Capybara.default_max_wait_time = ENV.fetch('MAX_WAIT_TIME').to_i

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
    headless.start
  end

  config.before :each do
    set_selenium_window_size(1280, 1024) if Capybara.current_driver == :selenium
  end

  config.around :each do |example|
    if [:video].include? example.metadata[:type]
      video_name = nil
      video_name = example.metadata[:full_description].downcase.gsub(/[^\w-]/, "-")
      headless.video.start_capture
    end

    example.run

    if [:video].include? example.metadata[:type]
      headless.video.stop_and_save "./video/#{video_name}.mov"
    end
  end

  config.after :all do
    headless.destroy
  end

  config.include Capybara::DSL
end
