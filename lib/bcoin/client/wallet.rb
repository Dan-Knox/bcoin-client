module Bcoin
  class Client
    class Wallet < Base

      def id
        @attributes[:id]
      end

      def base_path
        '/wallet/' + id.to_s
      end

      def accounts
        @accounts ||= Accounts.new(self).refresh!
      end

    end
  end
end
