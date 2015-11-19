require 'bundler/setup'
require 'rspec'
require 'capybara'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara/dsl'

# Capybara.javascript_driver = :poltergeist

Capybara.register_driver :poltergeist_debug do |app|
  options = {
      js_errors: false,
      inspector: true,
      window_size: [
          1280, 720
      ],
      # phantomjs_options: %w{
      #     "--loa# d-images=yes"
      #     "--ignore-ssl-errors=yes"
      #     "--web-security=false"
      # }
  }
  Capybara::Poltergeist::Driver.new(app, options)
end

Capybara.default_max_wait_time = 20
Capybara.javascript_driver = :poltergeist_debug

RSpec.configure do |config|
  config.before :each do
    page.driver.headers = {"User-Agent" => "Mozilla/6.0"}
  end

  config.before :all do
    #page.driver.headers = {
    #    "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36"
    #}
  end
end