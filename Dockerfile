FROM ruby:2.6.3-alpine

RUN apk add --no-cache \
    build-base \
    nodejs \
    git \
    openssh-client \
    bash 

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler:2.0.2

RUN bundle install

COPY . /app
