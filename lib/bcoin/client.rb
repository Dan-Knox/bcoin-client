require "bcoin/client/version"
require "bcoin/client/http_methods"
require "bcoin/client/base"
require "bcoin/client/wallet"
require "bcoin/client/account"
require "bcoin/client/balance"
require "bcoin/client/collection"
require "bcoin/client/wallets"
require "bcoin/client/accounts"
require "httparty"

module Bcoin
  class Client
    include HTTParty

    attr_reader :options

    format :json

    def initialize(options = {})
      @options = options
    end

    def port
      @options[:port] || 8332
    end

    def host
      @options[:host] || "localhost"
    end

    def username
      @options[:username]
    end

    def password
      @options[:password]
    end

    def base_uri
      [host, port].join(':')
    end

    def basic_auth
      password.nil? ? nil : {username: username, password: password}
    end

    def default_options
      {
        base_uri: base_uri,
        basic_auth: basic_auth
      }
    end

    def request method, path, options = {}
      options.merge! default_options
      self.class.send(method, path, options).parsed_response
    end

    def get path, options = {}
      request :get, path, query: options
    end

    def post path, options = {}
      request :post, path, body: options.to_json
    end

    def put path, options = {}
      request :put, path, body: options.to_json
    end

    def delete path, options = {}
      request :delete, path, body: options.to_json
    end

    def wallets
      @wallets ||= Wallets.new(self)
    end
  end
end
