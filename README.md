# minimal-chrome-on-heroku
Getting Chrome up and running on Heroku!

This is a sister repo of [jormon/minimal-chrome-on-heroku-xvfb](https://github.com/jormon/minimal-chrome-on-heroku-xvfb) which operates on the cedar-14 stack using xvfb.

I tried to keep the number of gems as minimal as possible, though I did include Thor for potential future uses with different configuration flags, etc.

Here are the rough needs to get this to work / notes:

  * There are some very hard-to-google configuration flags to set on your Chrome options, pay attention in the `new_browser` method if you're following along at home.
  * This uses watir for ease of scripting, but feel free to use raw Selenium.

# Deployment
You can use the following button to deploy this to a test instance and check it out yourself!

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

# Use
Once you deploy, from your commandline, simply run the following command with heroku toolbelt:

```
$ heroku run -a <insert-created-app-name> "thor runner google"
```
