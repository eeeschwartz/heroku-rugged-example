# Heroku Rugged example

This repo shows how you can get the `rugged` gem installed on Heroku.

It uses [heroku-buildpacks-multi](https://github.com/ddollar/heroku-buildpack-multi) so that it can run [heroku-buildpack-apt](https://github.com/ddollar/heroku-buildpack-apt) and [heroku buildpack-ruby](https://github.com/heroku/heroku-buildpack-ruby) at the same time. The dependencies are listed in `Aptfile` and `Gemfile`.

To create a Heroku app using heroku-buildpack-multi:

    $ heroku create --buildpack https://github.com/ddollar/heroku-buildpack-multi

Or in an existing app:

    $ heroku buildpacks:set https://github.com/ddollar/heroku-buildpack-multi.git
