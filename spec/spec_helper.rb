require 'bundler/setup'
require 'rspec'
require 'capybara'
require 'capybara/rspec'
require 'headless'
require 'selenium-webdriver'
require 'pry'

TEST_HOST = ENV['TEST_HOST'] || "http://dev1.host.development:9009/"
DATABOX_APP_HOST = ENV['DATABOX_APP_HOST'] || "https://new.databox.com"
DATABOX_USER_EMAIL = ENV.fetch('DATABOX_USER_EMAIL')
DATABOX_USER_PASS = ENV.fetch('DATABOX_USER_PASS')
WITH_VIDEO = (ENV['WITH_VIDEO'] || "1").to_i

Capybara.app_host = DATABOX_APP_HOST
Capybara.default_driver = :selenium
Capybara.server_port = 3000
Capybara.run_server = false
Capybara.javascript_driver = :selenium
Capybara.default_max_wait_time = ENV.fetch('MAX_WAIT_TIME').to_i
Capybara.automatic_reload = false

headless = Headless.new(
  display: 99,
  autopick: true,
  reuse: false,
  # destroy_at_exit: true,
  video: {
    frame_rate: 20,
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
    if [:video].include?(example.metadata[:type]) && WITH_VIDEO == 1
      video_name = nil
      video_name = example.metadata[:full_description].downcase.gsub(/[^\w-]/, "-")
      html_file = "./video/#{video_name}.html"
      video_file = "./video/#{video_name}.mov"

      File.open(html_file, 'w') do |file|
        file.write("
<html><title>Video Recording</title></html>
<style type='text/css'>html, body {width: 100%; margin: 0; padding: 0;} body { background-color: #000; }</style>
<body>
<video src='#{video_name}.mov' style='height: 100%; width:100%' autoplay controls>
</body>
</html>")
      end

      $stdout.puts "---> #{TEST_HOST}video/#{video_name}.html"
      headless.video.start_capture
    end

    example.run

    if [:video].include?(example.metadata[:type]) && WITH_VIDEO == 1
      headless.video.stop_and_save video_file
    end
  end

  config.after :all do
    headless.destroy
  end

  config.include Capybara::DSL
end
