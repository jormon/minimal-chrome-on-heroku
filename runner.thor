require "watir"
require "fileutils"

class Runner < Thor
  PAGES = %w(
    https://www.google.com/
    https://www.apple.com/
    https://www.facebook.com/
  ).freeze

  desc "website", "scrapes a website for its page title"
  def website
    browser = new_browser

    url = PAGES.sample
    browser.goto url

    title = browser.title

    if title.nil?
      puts "I've tried to load: #{url}, but it doesn't have a title."
    else
      puts "I've ended up loading: #{title}"
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
    if chrome_bin = ENV["GOOGLE_CHROME_SHIM"]
      options.add_argument "no-sandbox"
      options.binary = chrome_bin
      # give a hint to here too
      Selenium::WebDriver::Chrome.driver_path = chrome_bin
    end

    # headless!
    options.add_argument "window-size=1200x600"
    options.add_argument "headless"
    options.add_argument "disable-gpu"

    # make the browser
    Watir::Browser.new :chrome, options: options
  end
end
