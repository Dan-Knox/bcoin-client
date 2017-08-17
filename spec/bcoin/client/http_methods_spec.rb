require "spec_helper"

module Bcoin
  class Client

    class TestClass < Base
      include HttpMethods
      attr_reader :client, :attributes
      def initialize(client)
        @client = client
        @attributes = {}
      end
      def base_path
        '/test'
      end
    end

    RSpec.describe 'Bcoin::Client::HttpMethods' do

      let :client { Client.new }
      subject { TestClass.new(client) }

      it "stores a reference to the current Bcoin::Client instance" do
        expect(subject.client).to be_a Bcoin::Client
      end

      it "defines a #base_path" do
        expect(subject.base_path).to eq '/test'
      end

      [:get, :put, :post, :delete].each do |method|
        it "##{method} delegates to the client object with correct path" do
          expect(subject.client).to receive(method).with('/test/', {}).and_return({})
          subject.send method, '/'
        end

        it "sets the error attribute on failure" do
          expect(subject.client).to receive(method).and_return 'error' => true
          subject.send method, '/'
          expect(subject.error).to eq true
        end
      end

      it "returns nil for #wallet_token by default" do
        expect(subject.wallet_token).to eq nil
      end

    end
  end
end
