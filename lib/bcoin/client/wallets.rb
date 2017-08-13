require "bcoin/client/collection"
require "bcoin/client/wallet"

module Bcoin
  class Client
    class Wallets < Collection

      include Enumerable

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

    end
  end
end
