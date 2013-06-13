[![Build Status](https://travis-ci.org/amitkgupta/pair-exchange.png?branch=master)](https://travis-ci.org/amitkgupta/pair-exchange)

This app helps facilitate weekly-ish Pair Exchange events at the various Pivotal Labs offices.

## Tracker
<https://www.pivotaltracker.com/projects/717551/>

## Cloud Foundry
<http://pair-exchange.cfapps.io/>

## Heroku
<http://pivotal-pair-exchange.herokuapp.com/>

## Contributing
* Contact [amitkgupta](https://github.com/amitkgupta/) to get added to the Tracker project and get push permission for this repository.
* Work on an existing story in Tracker or work on something you'd like to add, but just make sure to add it to Tracker.
* `git pull --rebase` before pushing.
* You will need to set HOST, GOOGLE_OAUTH2_CLIENT_ID, and GOOGLE_OAUTH_CLIENT_SECRET environment variables for development.  See `config/environments/test.rb` for a sample.
* You will need to get your own Google OAuth2 credentials for API access.
* After you do so, add the following redirect URIs to the above Google client ID settings:
    http://localhost:3000/google_auth_callback
    http://localhost:8378/google_auth_callback
* Don't work on this on work machines for IP/legal reasons
