module Bcoin
  class Client
    class Account < Base

      # Contains an instance of Bcoin::Client::Wallet
      # which adheres to the HTTP client interface
      # but builds the URL correctly for the specific
      # wallet which this account belongs to.
      attr_reader :client

      def name
        @attributes[:name]
      end

      def base_path
        '/account/' + name.to_s
      end

    end
  end
end
