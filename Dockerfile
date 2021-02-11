FROM ruby:2.7.1-alpine

RUN apk add --no-cache \
    build-base \
    nodejs \
    git \
    openssh-client \
    bash

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler:2.2.8

RUN bundle install

COPY . /app
