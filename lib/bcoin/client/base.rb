module Bcoin
  class Client
    class Base

      include HttpMethods

      attr_reader :client, :attributes

      def initialize client, attr = {}
        @client = client
        self.attributes = attr
      end

      def inspect
        printf "#<%s @attributes=%p>", self.class.name, @attributes
      end

      # Override this in sub class
      def id
        'base'
      end

      # Override this in sub class
      def base_path
        '/base'
      end

      def refresh!
        self.attributes = get '/'
        self
      end

      def wallet_token
        @attributes[:token] if @attributes
      end

      def token= _token
        @attributes[:token] = _token
      end

      def attributes= attr
        @attributes = symbolize attr
      end

      def error= _error
        @attributes[:error] = _error
      end

      def respond_to? method
        @attributes[method] ? true : super
      end

      private

      def symbolize attr
        symbolized = {}
        attr.each do |k,v|
          symbolized[k.to_sym] = v
        end
        symbolized
      end

      def method_missing method, *args
        if @attributes[method].nil?
          raise NoMethodError
        else
          @attributes[method]
        end
      end

    end
  end
end
