module Bcoin
  class Client
    # Contains a copy of the HD Master Key. Depending
    # on the lock state of the wallet (see Wallet#unlock),
    # the master key will either be encrypted or in
    # plain text.
    class Master < Base

      # Contains an instance of Bcoin::Client::Wallet
      # which adheres to the HTTP client interface
      # but builds the URL correctly for the specific
      # wallet which this account belongs to.
      attr_reader :client

      def base_path
        '/master/'
      end

    end
  end
end
