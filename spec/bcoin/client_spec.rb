require "spec_helper"
require "ostruct"

MockResponse = OpenStruct.new(parsed_response: '')

module Bcoin
  RSpec.describe Client do
    it "has a version number" do
      expect(Client::VERSION).not_to be nil
    end

    it "includes HTTParty" do
      expect(Client.ancestors.include?(HTTParty)).to eq true
    end

    it "sets a default host" do
      expect(subject.host).to eq "localhost"
    end

    it "sets a default port" do
      expect(subject.port).to eq 8332
    end

    it "sets a base URI" do
      expect(subject.base_uri).to eq "localhost:8332"
    end

    it "accepts a username" do
      expect(Client.new(username: 'bcoin').username).to eq "bcoin"
    end

    it "accepts a password" do
      expect(Client.new(password: 'bcoin').password).to eq "bcoin"
    end

    describe "#basic_auth" do
      it "returns nil when no password is set" do
        expect(subject.basic_auth).to eq nil
      end

      it "returns a basic auth information when password is present" do
        expect(Client.new(password: 'bcoin').basic_auth).to eq({
          username: nil,
          password: 'bcoin'
        })
      end
    end

    it "#default_options sets the correct options" do
      expect(subject.default_options).to eq({
        base_uri: subject.base_uri,
        basic_auth: subject.basic_auth
      })
    end

    describe "#request" do
      it "calls the correct class method" do
        expect(Client).to receive(:get).and_return MockResponse
        subject.request :get, '/'
      end

      it "sets the correct default parameters" do
        expect(Client).to receive(:get)
          .with('/', subject.default_options)
          .and_return MockResponse
          
        subject.request :get, '/'
      end
    end

    it "#get delegates to #request correctly" do
      expect(subject).to receive(:request).with(:get, '/', query: {})
      subject.get '/'
    end

    [:post, :put, :delete].each do |method|
      it "##{method} delegates to #request correctly" do
        expect(subject).to receive(:request).with method, '/', {body: '{}'}
        subject.send method, '/'
      end
    end
  end
end
