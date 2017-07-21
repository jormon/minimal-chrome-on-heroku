  require "watir"
require "fileutils"

class Runner < Thor
  desc "google", "scrapes google.com for the google of the day"
  def google
    browser = new_browser

    browser.goto "https://www.google.com/"

    logo_div = browser.div(id: "hplogo")
    logo_div.wait_until_present

    image = logo_div.img
    subtext = logo_div.div(:class, "logo-subtext")

    if image.present?
      puts "Google says: #{image.alt}"
    elsif subtext.present?
      puts "No image, but you're on Google #{subtext.text}!"
    else
      puts "I've loaded google, but I'm on some site I don't recognize."
    end
  end

  private

  def new_browser
    options = Selenium::WebDriver::Chrome::Options.new

    # make a directory for chrome if it doesn't already exist
    chrome_dir = File.join Dir.pwd, %w(tmp chrome)
    FileUtils.mkdir_p chrome_dir
    user_data_dir = "--user-data-dir=#{chrome_dir}"
    # add the option for user-data-dir
    options.add_argument user_data_dir

    # let Selenium know where to look for chrome if we have a hint from
    # heroku. chromedriver-helper & chrome seem to work out of the box on osx,
    # but not on heroku.
    if chrome_bin = ENV["GOOGLE_CHROME_BIN"]
      options.add_argument "no-sandbox"
      options.binary = chrome_bin
      # give a hint to here too
      Selenium::WebDriver::Chrome.driver_path = \
        "/app/vendor/bundle/bin/chromedriver"
    end

    # headless!
    # keyboard entry wont work until chromedriver 2.31 is released
    options.add_argument "window-size=1200x600"
    options.add_argument "headless"
    options.add_argument "disable-gpu"

    # make the browser
    Watir::Browser.new :chrome, options: options
  end
end
