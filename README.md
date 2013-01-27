[![Build Status](https://travis-ci.org/amitkgupta/pair-exchange.png)](https://travis-ci.org/amitkgupta/pair-exchange)

This app helps facilitate weekly-ish Pair Exchange events at the various Pivotal Labs offices.

## Tracker
<https://www.pivotaltracker.com/projects/717551/>

## Heroku
<http://pivotal-pair-exchange.herokuapp.com/>

## Contributing
* Contact [amitkgupta](https://github.com/amitkgupta/) to get added to the Tracker project and get push permission for this repository.
* Work on an existing story in Tracker or work on something you'd like to add, but just make sure to add it to Tracker.
* `git pull --rebase` before pushing.
* Add a file `heroku_env.rb` in the `config` directory with the following content, and DO NOT check it into version control:
    ENV['GOOGLE_OAUTH2_CLIENT_ID'] = "<your_google_api_access_client_id>"
    ENV['GOOGLE_OAUTH2_CLIENT_SECRET'] = "<your_google_api_access_client_secret>"
* Add the following redirect URIs to the above Google client ID settings:
    http://localhost:3000/google_auth_callback
    http://localhost:8378/google_auth_callback
* Don't work on this on work machines for IP/legal reasons
