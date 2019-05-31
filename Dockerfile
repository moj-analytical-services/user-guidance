FROM ruby:2.6.3-alpine

RUN apk add --no-cache \
    build-base \
    nodejs \
    build-base \
    git \
    openssh-client \
    bash

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . /app
