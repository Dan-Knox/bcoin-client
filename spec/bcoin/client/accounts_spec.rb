require "spec_helper"

module Bcoin
  class Client
    RSpec.describe Accounts do

      # See comment for attr_reader :client in accounts.rb
      let(:client) { Client.new }
      let(:wallet) { Wallet.new(client, id: 'wallet123', token: 123) }
      subject { Accounts.new wallet, [1,2,3] }

      it "extends Collection" do
        expect(Accounts.ancestors.include?(Collection)).to eq true
      end

      it "stores a reference to the current Bcoin::Client::Wallet instance" do
        expect(subject.client).to be_a Bcoin::Client::Wallet
      end

      it "redefines #base_path" do
        expect(subject.base_path).to eq '/account'
      end

      it "refreshes it's accounts collection" do
        #pending "assholes be fucking me"
        expect(subject).to receive(:get).and_return([1,2,3])
        expect(subject.client).to receive(:get).at_least(3).times
          .and_return(load_mock!('wallet.json'))
        subject.refresh!
        expect(subject.first.network).to eq 'regtest'
      end

      it "returns self from #refresh!" do
        #pending "assholes be fucking me"
        expect(subject).to receive(:get).and_return []
        expect(subject.refresh!).to eq subject
      end

      describe "#find" do
        let(:account) { Account.new(wallet, {name: 'account123'}) }

        it "instantiates a new Account with the name attribute" do
          expect(wallet).to receive(:get).and_return({name: 'account123'})
          expect(Account).to receive(:new)
            .with(wallet, {name: 'account123'})
            .and_return account
          subject.find({name: 'account123'})
        end

        it "refreshes the account data" do
          expect(Account).to receive(:new)
            .and_return account
          expect(account).to receive(:refresh!)
          subject.find({id: 'account123'})
        end
      end

    end
  end
end
