require "spec_helper"

module Bcoin
  class Client
    RSpec.describe Balance do

      # See comment for attr_reader :client in account.rb
      let :client { Client.new }
      let :wallet { Wallet.new(client, id: 'wallet123', token: 123) }
      subject { Balance.new(wallet, name: 'account123') }

      it "extends Bcoin::Client::Base" do
        expect(Balance.ancestors.include?(Base)).to eq true
      end

      it "stores a reference to the current Bcoin::Client::Wallet instance" do
        expect(subject.client).to be_a Bcoin::Client::Wallet
      end

      it "redefines a #base_path" do
        expect(subject.base_path).to eq '/balance/'
      end

    end
  end
end
