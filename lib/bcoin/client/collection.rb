require "bcoin/client/http_methods"

module Bcoin
  class Client
    class Collection

      include Enumerable
      include HttpMethods

      attr_reader :client, :collection

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

      def refresh!
        get '/'
      end

    end
  end
end
