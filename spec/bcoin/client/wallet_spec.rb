require "spec_helper"

module Bcoin
  class Client
    class Accounts
      def refresh!
        self
      end
    end

    RSpec.describe Wallet do

      let :client { Client.new }
      subject { Wallet.new(client, id: 'wallet123', token: 123) }

      it "extends Bcoin::Client::Base" do
        expect(Wallet.ancestors.include?(Base)).to eq true
      end

      it "stores a reference to the current Bcoin::Client instance" do
        expect(subject.client).to be_a Bcoin::Client
      end

      it "redefines a #base_path" do
        expect(subject.base_path).to eq '/wallet/' + subject.id
      end

      it "redefines #id" do
        expect(subject.id).to eq 'wallet123'
      end

      describe "#accounts" do
        it "retrieves a list of accounts" do
          expect(subject.accounts).to be_a Accounts
        end

        it "sets the account's client object as self" do
          expect(subject.accounts.client).to eq subject
        end

        it "refreshes the account data" do
          accounts = Accounts.new(subject)
          expect(accounts).to receive(:refresh!)
          expect(Accounts).to receive(:new).and_return(accounts)
          subject.accounts
        end
      end

      describe "#balance" do
        it "retreives wallet balance information" do
          expect(subject).to receive(:get).and_return({confirmed: 1})
          expect(subject.balance).to be_a Client::Balance
          expect(subject.balance.confirmed).to eq 1
        end
      end

    end
  end
end
