# D-installer Integration Tests

This is just a proof of concept for the [D-Installer](
https://github.com/yast/d-installer) integration tests.

## Pre-requisities

### Webdriver

You need to install a [webdriver](https://www.w3.org/TR/webdriver/) which
can control and inspect a running web browser.

There are several ways:

1. **Installing a native package** - the webdriver might be available as a package,
   in openSUSE just run `zypper install chromedriver`. This will install the
   webdriver for the Chromium browser. *(This should be the preferred way.)*
2. **Manual download and installation** - download the webdriver for your browser
   manually
   - [Chromium Webdriver](https://chromedriver.chromium.org/downloads)
   - [Chrome Webdriver](https://chromedriver.storage.googleapis.com/index.html)
   - [FireFox Webdriver](https://github.com/mozilla/geckodriver/releases)
3. **Automatic download and installation** - there are several libraries or scripts
   which can automate the installation. For example you can use the [webdrivers](
   https://github.com/titusfortner/webdrivers) Ruby gem
   - Add `gem "webdrivers", "~> 4.6", require: false` to the `Gemfile`
   - Run `bundle update`
   - Add `require "webdrivers/chromedriver"` or `require "webdrivers/geckodriver"`
     depending which browser you want to use
   - Run the tests (see below), it will download and install the webdriver at
     the first run. In this case the files are installed into the `~/.webdrivers/`
     directory.

### Libraries

This proof of concept uses [selenium-webdriver](
https://github.com/SeleniumHQ/selenium/tree/trunk/rb) Ruby gem.

The libraries can be installed by running `bundle install --path .vendor/bundle`
command in the Git checkout.

### D-Installer

Download the D-Installer image from the [OBS Repository](
https://download.opensuse.org/repositories/YaST:/Head:/D-Installer/images/iso/).
For purposes of this test prefer the ALP image as it can install only one product
(ALP) and does not display the product selection dialog the start.

Then boot the installer image in a virtual machine.

## Running the tests

When the D-Installer is running you can run the tests using this command:

```shell
bundle exec rake INSTALLER_HOST=<IP_ADDRESS>
```

You can set some delay between the steps if you want to watch the steps with
`INSTALLER_DELAY=<seconds>` option.

## Found Problems

1. The D-installer by default uses a self-signed certificate. You need to
   explicitly accept it in the browser. (Or maybe the certificate check can be
   disabled somehow?)
2. The D-Installer is basically a single page application, that means you can
   do not need to start the browser for each separate test. That can speed up
   testing.
3. Because the D-Installer uses ReactJS and all changes in the page are done
   asynchronously using JavaScript you need to wait for the expected objects
   to appear or change in the page.

## Links

- [Selenium documentation](https://www.selenium.dev/documentation/webdriver/)
- [Selenium Ruby documentation](https://www.selenium.dev/selenium/docs/api/rb/Selenium/WebDriver.html)
