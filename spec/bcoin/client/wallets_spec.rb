require "spec_helper"

module Bcoin
  class Client

    class Wallet
      # Override #refresh! in wallet to avoid network calls
      def refresh!
        self
      end
    end

    RSpec.describe Wallets do

      let :client { Client.new }
      subject { Wallets.new client, [1,2,3] }

      it "extends Collection" do
        expect(Wallets.ancestors.include?(Collection)).to eq true
      end

      it "stores a reference to the current Bcoin::Client instance" do
        expect(subject.client).to be_a Bcoin::Client
      end

      it "redefines #base_path" do
        expect(subject.base_path).to eq '/wallet/_admin/wallets'
      end

      it "refreshes it's wallets collection" do
        expect(Wallet).to receive(:new)
          .exactly(3)
          .times do |c, attr|
            expect(c).to be_a Client
            expect([1,2,3].include?(attr[:id])).to eq true
          end.and_call_original
        expect(subject).to receive(:get).and_return([1,2,3])
        subject.refresh!
      end

      it "returns self from #refresh!" do
        expect(subject).to receive(:get).and_return []
        expect(subject.refresh!).to eq subject
      end

      describe "#find" do
        let :wallet { Wallet.new(client, {id: 'wallet', token: 123}) }

        it "instantiates a new Wallet with an id and optional token" do
          expect(Wallet).to receive(:new)
            .with(client, {id: 'wallet', token: 123})
            .and_return wallet
          subject.find({id: 'wallet', token: 123})
        end

        it "refreshes the wallet data" do
          expect(Wallet).to receive(:new)
            .and_return wallet
          expect(wallet).to receive(:refresh!)
          subject.find({id: 'wallet', token: 123})
        end
      end

    end
  end
end
