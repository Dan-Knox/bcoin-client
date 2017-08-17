require "bcoin/client/collection"
require "bcoin/client/wallet"

module Bcoin
  class Client
    class Wallets < Collection

      attr_reader :client

      # The base path for the wallets collection must be
      # set to '/' since the bcoin API breaks from the
      # RESTful standard for the retrieval of the wallet
      # collection. The list of wallets is located at
      # '/wallets/_admin/wallets'. The base path for all
      # other wallet operations is the expected '/wallet'.
      def base_path
        '/'
      end

      def refresh!
        # Preceeding slash in the GET operation intentionally omitted
        # due to wonkiness with the wallets base path. See the
        # Wallets#base_path comment above.
        @collection = super('wallet/_admin/wallets').collect { |w|
          Wallet.new(client, id: w).refresh!
        }
        self
      end

      def find attr
        Wallet.new(client, attr).refresh!
      end

      # Create a new Wallet.
      # @params [Hash] opts The options for creating the wallet.
      # @option opts [String] :id The ID for the new wallet.
      # @option opts [String] :type The type for the wallet.
      #   :pubkeyhash, :witness etc...
      # @options opts [String] :mnemonic The wallet mnemonic.
      # @return [Bcoin::Client::Wallet] The new wallet object.
      def create options = {}
        # The path in this post operation intentionally omits
        # the preceeding slash due to wonkiness with the wallets
        # base path breaking standards. See Wallets#base_path
        # comment above.
        response = post 'wallet/', options
        Wallet.new(client, response)
      end

    end
  end
end
