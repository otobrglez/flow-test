require 'spec_helper'

APP_HOST = "https://new.databox.com"
EMAIL = 'oto@databox.com'
PASS = 'karkoli123'

def vsleep(time, tag="")
  puts "Sleeping %s" % tag
  sleep time
  puts "Done sleeping %s" % tag
end

RSpec.describe "Basic page visit", type: :feature, js: true do

  before :all do
    Capybara.app_host = APP_HOST
  end

  it "visits homepage" do
    visit '/'
    page.save_screenshot 'shots/001.jpg'

    within("div.form-slider") do
      fill_in 'email', with: EMAIL
      fill_in 'password', with: PASS
    end

    click_on 'Sign in'
    vsleep 4, 'Waiting for login'
    # page.save_screenshot 'shots/002.jpg'

    click_on 'Data Manager'
    vsleep 5, 'Waiting for "Data Manager"'
    page.save_screenshot 'shots/003.jpg'

    find(:xpath, '//a[contains(@class, "greenbutton")]').click
    vsleep 3, 'Waiting for "New connection"'
    page.save_screenshot 'shots/004.jpg'

    find(:xpath, "//div[@id='servicesList']//li[2]//a").click

    sleep 2
    page.save_screenshot 'shots/004-a.jpg'

=begin
    connect_window = window_opened_by do
      puts find(:xpath, "//div[@id='servicesList']//li[2]").click
      vsleep 4, 'Waiting popup'
    end

    within_window connect_window do
      page.save_screenshot 'shots/005.jpg'
    end
=end

  end

end