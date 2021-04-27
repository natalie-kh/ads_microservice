#!/bin/sh

gem install bundler -v 2.1.4
bundle install

bundle exec rake db:create

echo Start migrations
bundle exec rake db:migrate
echo Migrations done!

bundle exec rackup --host 0.0.0.0 -p 4567
