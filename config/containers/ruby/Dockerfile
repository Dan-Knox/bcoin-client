FROM ruby:2.2.5
MAINTAINER Daniel Knox <dk@bitfs.us>
ENV REFRESHED_AT 2017-08-09

RUN apt-get update -qq && apt-get install -y build-essential

# cleanup
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /bcoin-client

ADD . /bcoin-client
WORKDIR /bcoin-client

RUN gem install bundler
RUN bundle install

CMD ['bundle', 'exec', 'rspec']
