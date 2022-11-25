require "rspec"
require "selenium-webdriver"

installer_host = ENV["INSTALLER_HOST"] || "localhost"
puts "D-Installer host: #{installer_host}"

RSpec.configure do |config|
  config.before(:all) do
    # use this object to wait for some object to appear on the page
    @wait = Selenium::WebDriver::Wait.new(:timeout => 20)
    @driver = Selenium::WebDriver.for(:chrome)

    @driver.navigate.to "https://#{installer_host}:9090/cockpit/@localhost/d-installer/index.html"
    @delay = ENV["INSTALLER_DELAY"].to_i

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
      sleep(@delay)
      password.send_keys(pwd)
      sleep(@delay)

      @driver.find_element(id: "login-button").click
      sleep(@delay)
    rescue Selenium::WebDriver::Error::NoSuchElementError
    end
  end

  config.after(:all) do
    @driver.quit if @driver
  end
end
