require "spec_helper"

module Bcoin
  class Client

    RSpec.describe Wallets do

      let(:client) { Client.new }
      subject { Wallets.new client, [1,2,3] }

      it "extends Collection" do
        expect(Wallets.ancestors.include?(Collection)).to eq true
      end

      it "stores a reference to the current Bcoin::Client instance" do
        expect(subject.client).to be_a Bcoin::Client
      end

      it "redefines #base_path" do
        expect(subject.base_path).to eq '/'
      end

      it "refreshes it's wallets collection" do
        wallet = Wallet.new(client)
        expect(wallet).to receive(:refresh!)
          .at_most(3).times

        expect(Wallet).to receive(:new)
          .exactly(3)
          .times do |c, attr|
            expect(c).to be_a Client
            expect([1,2,3].include?(attr[:id])).to eq true
          end.and_return wallet

        expect(subject).to receive(:get).and_return([1,2,3])
        subject.refresh!
      end

      it "returns self from #refresh!" do
        expect(subject.client).to receive(:get)
          .with('/wallet/_admin/wallets/', {})
          .and_return []
        expect(subject.refresh!).to eq subject
      end

      describe "#find" do
        let(:wallet) { Wallet.new(client, {id: 'wallet', token: 123}) }
        before do
          expect(wallet).to receive :refresh!
        end

        it "instantiates a new Wallet with an id and optional token" do
          expect(Wallet).to receive(:new)
            .with(client, {id: 'wallet', token: 123})
            .and_return wallet

          subject.find({id: 'wallet', token: 123})
        end

        it "refreshes the wallet data" do
          expect(Wallet).to receive(:new)
            .and_return wallet
            
          subject.find({id: 'wallet', token: 123})
        end
      end

      describe "#create" do
        let(:wallet_json) { load_mock! 'wallet.json' }

        it "sends an HTTP Post to base_path with options" do
          expect(subject.client).to receive(:post)
            .with('/wallet/', id: 'btcme', type: :pubkeyhash)
            .and_return wallet_json

          subject.create id: 'btcme', type: :pubkeyhash
        end

        it "returns a new wallet object" do
          expect(subject.client).to receive(:post)
            .and_return wallet_json

          wallet = subject.create id: 'btcme', type: :pubkeyhash
          expect(wallet).to be_a Wallet
          expect(wallet.id).to eq 'btcme'
        end
      end

    end
  end
end
