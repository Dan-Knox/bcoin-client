require "bcoin/client/collection"
require "bcoin/client/wallet"

module Bcoin
  class Client
    class Wallets < Collection

      attr_reader :client

      def base_path
        '/wallet/_admin/wallets'
      end

      def refresh!
        @collection = super.collect { |w|
          Wallet.new(client, id: w).refresh!
        }
        self
      end

      def find attr
        Wallet.new(client, attr).refresh!
      end

    end
  end
end
