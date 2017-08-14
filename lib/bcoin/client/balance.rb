module Bcoin
  class Client
    class Balance < Base

      # Contains an instance of Bcoin::Client::Wallet
      # which adheres to the HTTP client interface
      # but builds the URL correctly for the specific
      # wallet which this account belongs to.
      attr_reader :client

      def base_path
        '/balance/'
      end

    end
  end
end
