require "bcoin/client/version"
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
      self.class.send method, path, options
    end

    def get path, options = {}
      request :get, path, options
    end

    def post path, options = {}
      request :post, path, options
    end

    def put path, options = {}
      request :put, path, options
    end

    def delete path, options = {}
      request :delete, path, options
    end
  end
end
