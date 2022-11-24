require_relative '../lib/test_helper'

describe "D-Installer" do
  it "sets the page title" do
    title = "D-Installer"
    @wait.until { @driver.title == title }
  end

  it "contains the 'Install' button" do
    @wait.until { @driver.find_element(xpath: "//button[text()='Install']") }
  end
end
