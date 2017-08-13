module Bcoin
  class Client
    module HttpMethods

      # Override this in sub class
      def base_path
        '/base'
      end

      def get path, options = {}
        options[:token] = wallet_token if wallet_token
        @client.get base_path + path, options
      end

      def post path, options = {}
        options[:token] = wallet_token if wallet_token
        @client.post base_path + path, options
      end

      def put path, options = {}
        options[:token] = wallet_token if wallet_token
        @client.put base_path + path, options
      end

      def delete path, options = {}
        options[:token] = wallet_token if wallet_token
        @client.delete base_path + path, options
      end

      def wallet_token
        nil
      end

    end
  end
end
