FROM ruby:2.3

COPY Gemfile /usr/src/app/Gemfile
WORKDIR /usr/src/app
RUN bundler install
