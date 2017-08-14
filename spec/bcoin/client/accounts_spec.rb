require "spec_helper"

module Bcoin
  class Client

    class Account
      # Override #refresh! in wallet to avoid network calls
      def refresh!
      end
    end

    RSpec.describe Accounts do

      # See comment for attr_reader :client in accounts.rb
      let :client { Client.new }
      let :wallet { Wallet.new(client, id: 'wallet123', token: 123) }
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

      it "refreshes it's wallets collection" do
        expect(Account).to receive(:new)
          .exactly(3).times do |c, attr|
            expect(c).to be_a Client::Wallet
            expect([1,2,3].include?(attr[:name])).to eq true
          end.and_call_original

        expect(subject).to receive(:get).and_return([1,2,3])
        subject.refresh!
      end

      it "returns self from #refresh!" do
        expect(subject).to receive(:get).and_return []
        expect(subject.refresh!).to eq subject
      end

      describe "#find" do
        let :account { Account.new({name: 'account123'}) }

        it "instantiates a new Account with an id and optional token" do
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
