require 'rspec'
require 'selenium-webdriver'

# if you enable "webdrivers" Ruby gem in Gemfile then the webdrivers can
# be installed automatically
#
# require 'webdrivers/chromedriver'
# require 'webdrivers/geckodriver'

installer_host = ENV["INSTALLER_HOST"] || "localhost"
puts "D-Installer host: #{installer_host}"

RSpec.configure do |config|
  config.around(:example) do |example|
    # use this object to wait for some object to appear on the page
    @wait = Selenium::WebDriver::Wait.new(:timeout => 20)
    @driver = Selenium::WebDriver.for(:chrome)

    @driver.navigate.to "https://#{installer_host}:9090/cockpit/@localhost/d-installer/index.html"

    # handle SSL certificate problem
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

    begin
      example.run
    ensure 
      @driver.quit
    end
  end
end
