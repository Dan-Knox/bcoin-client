require "bcoin/client/accounts"
require "bcoin/client/balance"

module Bcoin
  class Client
    class Wallet < Base

      def id
        @attributes[:id]
      end

      def base_path
        '/wallet/' + id.to_s
      end

      # Retrieve a list of acounts with details.
      # @return [Bcoin::Client::Accounts]
      def accounts
        @accounts ||= Accounts.new(self).refresh!
      end

      # Retrieve balance information for this wallet.
      # @return [Bcoin::Client::Balance]
      def balance
        @balance ||= Balance.new(self).refresh!
      end

      # Reset the wallet passphrase. Useful for locking
      # and unlocking the the master key and wallet coins.
      # @param [Hash] opts The options for resetting
      #   the wallet passphrase.
      # @option opts [String] :old The old password.
      # @option opts [String] :new The new password.
      # @return [true, false] True if successful.
      def passphrase options = {}
        post '/passphrase', options
        !error?
      end

      # Unlock the wallet master key for retrieval of
      # the wallet mnemonic, and key in plain text for
      # 'timeout' number of seconds.
      # @params [Hash] opts The options for unlocking
      #   the wallet master key.
      # @option opts [String] :passphrase The wallet passphrase.
      # @option opts [Integer] :timeout Seconds to unlock the wallet for.
      # @return [true, false] True if succesful.
      def unlock options = {}
        post '/unlock', options
        !error?
      end

      # Locks the wallet master key.
      # @return [true, false] True if succesful.
      def lock
        post '/lock'
        !error?
      end

      # Retrieves a new wallet API token.
      # @return [Hash] opts
      # @option opts :token The new wallet API token.
      def retoken
        response = post '/retoken'

        if error?
          false
        else
          @attributes[:token] = response['token']
          true
        end
      end

      # Checks for an error returned during a request.
      # @return [true, false]
      def error?
        @attributes[:error] ? true : false
      end

    end
  end
end
