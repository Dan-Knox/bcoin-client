FROM node:8.2.1
MAINTAINER Dan Knox <dk@bitfs.us>
ENV REFRESHED_AT 2017-08-09

ENV PATH ./node_modules/.bin/:$PATH

RUN mkdir -p /bcoin

ADD . /bcoin
WORKDIR /bcoin

RUN npm install

EXPOSE 8332

ENV BCOIN_API_KEY bcoin-ruby
ENV BCOIN_NETWORK testnet

CMD ['/bcoin/node_modules/.bin/bcoin --config=/bcoin/bcoin.conf']
