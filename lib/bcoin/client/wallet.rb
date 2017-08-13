module Bcoin
  class Client
    class Wallet < Base

      def id
        @attributes[:id]
      end

      def base_path
        '/wallet/' + id.to_s
      end

    end
  end
end
