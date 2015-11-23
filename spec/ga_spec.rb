require 'spec_helper'

GA_EMAIL="apps@databox.com"
GA_PASS="data4all"

RSpec.describe "GoogleAnalytics" do

  it "login and connect" do
    visit '/'

    expect(page).to have_selector('div.form-slider')

    within("div.form-slider") do
      fill_in 'email', with: EMAIL
      fill_in 'password', with: PASS
    end

    click_on 'Sign in'
    expect(page).to have_selector("#navbar li.datamanager")

    click_on 'Data Manager'
    expect(page).to have_selector("a.greenbutton")
    find("a.greenbutton").click

    within "#servicesList" do
      links = all 'li a'
      links.each do |a|
        expect(a).to match /Connect/
      end
    end

    connect_window = window_opened_by do
      page.execute_script('$("#servicesList li:nth(1) a").trigger("click")')
    end

    within_window connect_window do
      expect(page).to have_content 'Google'

      fill_in 'Email', with: GA_EMAIL
      fill_in 'Password', with: GA_PASS
      click_button 'Sign in'

      expect(page).to have_content "Dovoli"
      click_button "Dovoli" # Yeah :)
    end

    find("a.greenbutton").click
    expect(page).to have_content "Please select web property"
    page.execute_script('$("form.profile label:last()").trigger("click")')
    find("a.greenbutton").click
    expect(page).to have_content "All Web Site Data"
    page.execute_script('$("form.profile label:last()").trigger("click")')
    find("a.greenbutton").click

    expect(page).to have_content "data fetched!"
    sleep 2
  end

end
