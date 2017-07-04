# minimal-chrome-on-heroku-xvfb
Getting Chrome up and running of Heroku

I tried to keep the number of gems as minimal as possible, though I did include Thor for potential future uses with different configuration flags, etc.

Here are the rough needs to get this to work / notes:

  * Be comfortable with cedar-14 if you want to use headless mode
  * There are some very hard-to-google configuration flags to set on your Chrome options, pay attention in the `new_browser` method if you're following
  along at home.
  * This uses the older [heroku chrome xvfb buildpack](https://github.com/heroku/heroku-buildpack-xvfb-google-chrome).
  * This uses watir for ease of scripting, but feel free to use raw Selenium.

# Deployment
You can use the following button to deploy this to a test instance and check it out yourself!

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

# Use
Once you deploy, from your commandline, simply run the following command with heroku toolbelt:

```
$ heroku run -a <insert-created-app-name> "thor runner google"
```
