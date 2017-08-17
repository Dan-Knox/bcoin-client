module Bcoin
  class Client
    module HttpMethods

      # Override this in sub class
      def base_path
        '/base'
      end

      def get path, options = {}
        options[:token] = wallet_token if wallet_token
        response = @client.get base_path + path, options
        set_error_from response
        response
      end

      def post path, options = {}
        options[:token] = wallet_token if wallet_token
        response = @client.post base_path + path, options
        set_error_from response
        response
      end

      def put path, options = {}
        options[:token] = wallet_token if wallet_token
        response = @client.put base_path + path, options
        set_error_from response
        response
      end

      def delete path, options = {}
        options[:token] = wallet_token if wallet_token
        response = @client.delete base_path + path, options
        set_error_from response
        response
      end

      # Override this is sub class
      def wallet_token
        nil
      end

      private

      def set_error_from response = {}
        if response.is_a?(Hash) &&  response['error']
          self.error = response['error']
        end
      end

    end
  end
end
