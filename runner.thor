require "webdrivers/chromedriver"
require "watir"
require "fileutils"

class Runner < Thor
  PAGES = %w(
    https://www.google.com/
    https://www.apple.com/
    https://www.facebook.com/
  ).freeze

  desc "download", "tests downloading a file from a website"
  def download
    browser = new_browser(downloads: true)

    browser.goto "https://tools.ietf.org/html/rfc7231"

    download_link = browser.a(css: "[title='PDF version of this document']")

    download_link.click

    sleep 5
  end

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

  def new_browser(downloads: false)
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
      options.add_argument "--no-sandbox"
      options.binary = chrome_bin
    end

    # headless!
    options.add_argument "--window-size=1200x600"
    options.add_argument "--headless"
    options.add_argument "--disable-gpu"

    # make the browser
    browser = Watir::Browser.new :chrome, options: options

    # setup downloading options
    if downloads
      # make download storage directory
      downloads_dir = File.join Dir.pwd, %w(tmp downloads)
      FileUtils.mkdir_p downloads_dir

      # tell the bridge to use downloads
      bridge = browser.driver.send :bridge
      path = "/session/#{bridge.session_id}/chromium/send_command"
      params = { behavior: "allow", downloadPath: downloads_dir }
      bridge.http.call(:post, path, cmd: "Page.setDownloadBehavior",
                                    params: params)
    end
    browser
  end
end
