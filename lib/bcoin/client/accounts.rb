require "bcoin/client/collection"
require "bcoin/client/account"

module Bcoin
  class Client
    class Accounts < Collection

      # Contains an instance of Bcoin::Client::Wallet
      # which adheres to the HTTP client interface
      # but builds the URL correctly for the specific
      # wallet which this account belongs to.
      attr_reader :client

      def base_path
        '/account'
      end

      def refresh!
        @collection = super.collect { |w|
          Account.new(client, name: w).refresh!
        }
        self
      end

      def find attr
        Account.new(client, attr).refresh!
      end

    end
  end
end
