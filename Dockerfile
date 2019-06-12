FROM ruby:2.6.3-alpine

RUN apk add --no-cache \
    build-base \
    nodejs \
    build-base \
    git \
    openssh-client \
    bash \
    python3 \
    python3-dev

RUN pip3 install awscli

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler:2.0.1

RUN bundle install

COPY . /app
