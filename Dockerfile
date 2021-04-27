FROM ruby:2.6.3

RUN apt-get update -qq && apt-get install -y build-essential

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

RUN gem install bundler -v 2.1.4
RUN bundle install

ADD .docker $APP_HOME
COPY .docker/entrypoints /entrypoints
RUN chmod 755 -R /entrypoints
