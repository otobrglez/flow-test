require 'spec_helper'

GA_EMAIL="apps@databox.com"
GA_PASS="data4all"

RSpec.describe "GoogleAnalytics" do
  it "login and connect", type: :video do
    visit '/'

    expect(page).to have_selector('div.form-slider')

    within("div.form-slider") do
      fill_in 'email', with: DATABOX_USER_EMAIL
      fill_in 'password', with: DATABOX_USER_PASS
    end

    page.execute_script('$(document).ajaxError(function myErrorHandler(event, xhr, ajaxOptions, thrownError) {
      alert(JSON.stringify({
        msg: "AJAX ERROR",
        event: event,
        xhr: xhr,
        ajaxOptions: ajaxOptions,
        thrownError: thrownError
      }));
    });')


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
      page.execute_script("$('#servicesList li[data-ds_type=\\'GoogleAnalytics\\'] a').trigger('click')")
    end

    within_window connect_window do
      expect(page).to have_content 'Google'

      fill_in 'Email', with: GA_EMAIL
      fill_in 'Password', with: GA_PASS
      click_button 'Sign in'

      expect(page).to have_content(/Allow|Dovoli/i)
      sleep 1
      find("button", text:/Allow|Dovoli/i).click
    end

    # We come back from popup-callback
    find("a.greenbutton").click
    expect(page).to have_content "Please select web property"
    page.execute_script('$("form.profile label:last()").trigger("click")')
    find("a.greenbutton").click

    sleep 2

    expect(page).to have_content "All Web Site Data"
    page.execute_script('$("form.profile label:last()").trigger("click")')
    find("a.greenbutton").click

    # We wait for fetched
    expect(page).to have_content "data fetched!"
    data_source_name = find("#infolayer p strong").text

    # We go back to connections
    click_on 'Active Data Connections'
    expect(page).to have_content data_source_name
    # puts "data_source_name: #{data_source_name}"

    # Find index of DS to delete
    texts = all(:xpath, "//table//td[@class='c1']/strong").map(&:text)
    index = texts.index {|t| t.strip == data_source_name.strip}
    expect(index).to be >= 0

    # Click 'Edit', click 'Delete', click 'Confirm'
    page.execute_script('$("#sourcesList tr:nth(1) .settings a").trigger("click")')
    expect(page).to have_content "Delete"
    page.execute_script('$("div.popup-inner .delete a").trigger("click")')
    expect(page).to have_content "Confirm"
    page.execute_script('$("a.confirm-yes").trigger("click")')

    expect(page).to have_content "deleted!"

    page.execute_script('alert("Google Analytics Done.");')
    sleep 3
  end
end
