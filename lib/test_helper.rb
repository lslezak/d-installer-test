require "rspec"
require "selenium-webdriver"

base_url = ENV["BASE_URL"] || "http://localhost:9090"
puts "D-Installer host: #{base_url}"

RSpec.configure do |config|
  config.before(:all) do
    # use this object to wait for some object to appear on the page
    @wait = Selenium::WebDriver::Wait.new(:timeout => 20)
    @driver = Selenium::WebDriver.for(:chrome)

    @driver.navigate.to "#{base_url}/cockpit/@localhost/d-installer/index.html"

    # handle SSL certificate problem
    # TODO: this is for Chrome/Chromium browser, add more
    if @driver.title == "Privacy error"
      puts "[Accepting SSL exception]"
      advanced = @driver.find_element(id: "details-button")
      advanced.click
      proceed = @driver.find_element(id: "proceed-link")
      proceed.click
    end

    # optionally login in to the service, when running locally the password is not required
    begin
      login = @driver.find_element(id: "login-user-input")
      password = @driver.find_element(id: "login-password-input")

      user = ENV["INSTALLER_USER"] || "root"
      pwd = ENV["INSTALLER_PASSWORD"] || "linux"
      login.send_keys(user)
      password.send_keys(pwd)

      @driver.find_element(id: "login-button").click
    rescue Selenium::WebDriver::Error::NoSuchElementError
    end

    # use this object to wait for some object to appear on the page
    # https://www.selenium.dev/documentation/webdriver/waits/#implicit-wait
    @driver.manage.timeouts.implicit_wait = 20
  end

  config.after(:all) do
    @driver.quit if @driver
  end
end
