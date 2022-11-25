require_relative "../lib/test_helper"

page_title = "D-Installer"
install_button = "Install"

describe "D-Installer" do
  it "sets the page title to #{page_title.inspect}" do
    @wait.until { @driver.title == page_title }
  end

  it "contains the #{install_button.inspect} button" do
    @wait.until { @driver.find_element(xpath: "//button[text()='#{install_button}']") }
  end

  it "can set the root password" do
    sleep(@delay)
    @wait.until { @driver.find_element(class: "overview-users") }
    overview_users = @driver.find_element(class: "overview-users")

    root = nil
    @wait.until do
      user_config_items = overview_users.find_elements(tag_name: "p")
      root = user_config_items.find{|i| i.text.start_with?("Root password is ")}
    end

    root_password_button = root.find_element(tag_name: "button")
    expect(root_password_button).to_not be_nil

    root_password_button.click
    sleep(@delay)

    # wait until the popup is displayed
    @wait.until { @driver.find_element(id: "rootPassword") }

    password = @driver.find_element(id: "rootPassword")
    password.send_keys("d-installer")
    sleep(@delay)

    confirm = @driver.find_element(xpath: "//button[@type='submit']")
    confirm.click
    sleep(@delay)

    @wait.until { @driver.find_element(class: "overview-users") }
    user_config_items = @driver.find_element(class: "overview-users").find_elements(tag_name: "p")
    root = user_config_items.find { |i| i.text == "Root password is set" }

    expect(root).to_not be_nil
  end
end
