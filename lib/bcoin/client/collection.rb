require "bcoin/client/http_methods"

module Bcoin
  class Client
    class Collection

      include Enumerable
      include HttpMethods

      attr_reader :client, :collection, :error

      def initialize client, collection = []
        @client = client
        @collection = collection
      end

      # Redefine in sub class
      def base_path
        '/collection'
      end

      def each &block
        @collection.each {|w| block.call(w) }
      end

      # Allow for overriding of the path for situations
      # like the wallet list retrieval. See the comment
      # for Wallets#base_path for details.
      def refresh! path = ''
        get path + '/'
      end

      def error?
        @error ? true : false
      end

      def error=(_error)
        @error = _error
      end

    end
  end
end
