require_relative '../lib/test_helper'

page_title = "D-Installer"
install_button = "Install"

describe "D-Installer" do
  it "sets the page title to #{page_title.inspect}" do
    @wait.until { @driver.title == page_title }
  end

  it "contains the #{install_button.inspect} button" do
    @wait.until { @driver.find_element(xpath: "//button[text()='#{install_button}']") }
  end
end
