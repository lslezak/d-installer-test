require_relative "../lib/test_helper"

page_title = "D-Installer"
install_button = "Install"

describe "D-Installer" do
  it "sets the page title to #{page_title.inspect}" do
    @wait.until { @driver.title == page_title }
  end

  it "contains the #{install_button.inspect} button" do
    @driver.find_element(xpath: "//button[text()='#{install_button}']")
  end

  it "can set the root password" do
    @driver.find_element(class: "overview-users")
    overview_users = @driver.find_element(class: "overview-users")

    root = @wait.until do
      user_config_items = overview_users.find_elements(tag_name: "p")
      root = user_config_items.find{|i| i.text.start_with?("Root password is ")}
    end
    root.find_element(tag_name: "button").click

    @driver.find_element(id: "password").send_keys("d-installer")
    @driver.find_element(id: "passwordConfirmation").send_keys("d-installer")

    @driver.find_element(xpath: "//button[@type='submit']").click

    user_config_items = @driver.find_element(class: "overview-users").find_elements(tag_name: "p")
    root =  @wait.until { user_config_items.find { |i| i.text == "Root password is set" } }

    expect(root).to_not be_nil
  end
end
