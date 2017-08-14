require "spec_helper"

module Bcoin
  class Client
    RSpec.describe Account do

      # See comment for attr_reader :client in account.rb
      let :client { Client.new }
      let :wallet { Wallet.new(client, id: 'wallet123', token: 123) }
      subject { Account.new(wallet, name: 'account123') }

      it "extends Bcoin::Client::Base" do
        expect(Account.ancestors.include?(Base)).to eq true
      end

      it "stores a reference to the current Bcoin::Client::Wallet instance" do
        expect(subject.client).to be_a Bcoin::Client::Wallet
      end

      it "redefines a #base_path" do
        expect(subject.base_path).to eq '/account/' + subject.name
      end

      it "redefines #name" do
        expect(subject.name).to eq 'account123'
      end

    end
  end
end
