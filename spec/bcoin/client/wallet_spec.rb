require "spec_helper"

module Bcoin
  class Client

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
        before do
          expect(subject).to receive(:get).and_return []
        end
        
        it "retrieves a list of accounts" do
          expect(subject.accounts).to be_a Accounts
        end

        it "sets the account's client object as self" do
          expect(subject.accounts.client).to eq subject
        end

        it "refreshes the account data" do
          accounts = Accounts.new(subject)
          expect(accounts).to receive(:refresh!).and_call_original
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

      describe "#passphrase" do
        it "send the correct HTTP request" do
          expect(subject).to receive(:post)
            .with('/passphrase', {old: 'oldpass', new: 'newpass'})
            .and_return({'success': true})

          subject.passphrase old: 'oldpass', new: 'newpass'
        end

        it "sets the error attribute on failure" do
          expect(subject.client).to receive(:post).and_return 'error' => 'some error'
          subject.passphrase old: 'oldpass', new: 'newpass'
          expect(subject.error?).to eq true
        end

        it "returns true on success" do
          expect(subject.client).to receive(:post).and_return 'success' => true
          res = subject.passphrase old: 'oldpass', new: 'newpass'
          expect(res).to eq true
        end

        it "returns false on error" do
          expect(subject.client).to receive(:post).and_return 'error' => true
          res = subject.passphrase old: true, new: true
          expect(res).to eq false
        end
      end

      describe "#unlock" do
        it "unlocks the wallet's master key for 'timeout' seconds" do
          expect(subject).to receive(:post)
            .with('/unlock', passphrase: 'testpass', timeout: 60)
            .and_return 'success' => true

          subject.unlock passphrase: 'testpass', timeout: 60
        end
      end

      describe "#unlock" do
        it "locks the wallet's master key" do
          expect(subject).to receive(:post)
            .with('/lock')
            .and_return 'success' => true

          subject.lock
        end
      end

      describe "#master" do
        let(:master_json) { load_mock! 'master.json' }

        it "retrieves the wallet's master key" do
          expect(subject).to receive(:get)
            .with('/master')
            .and_return master_json

          expect(subject.master).to be_a Bcoin::Client::Master
          expect(subject.master.client).to eq subject
        end
      end

      describe "#retoken" do
        it "retrieves a new wallet API token" do
          expect(subject).to receive(:post)
            .with('/retoken')
            .and_return 'token' => 'RETOKENME'

          subject.retoken
          expect(subject.token).to eq 'RETOKENME'
        end
      end

      describe "#send" do
        it "sends a new transaction to the bitcoin node" do
          expect(subject).to receive(:post)
            .with('/send', rate: 0.005, outputs: [{value: 1, address: 'btcaddr'}])

            subject.send rate: 0.005, outputs: [{value: 1, address: 'btcaddr'}]
        end

        it "returns the new transaction on success" do
          expect(subject).to receive(:post)
            .and_return load_mock! 'send.json'

          expect(subject.send rate: 0.005).to be_a Hash
        end

        it "returns false on failure" do
          expect(subject.client).to receive(:post)
            .and_return 'error' => 'some error'

          expect(subject.send rate: 0.005).to eq false
        end
      end

      describe "#error?" do
        it "returns true when error is present" do
          subject.attributes[:error] = 'other error'
          expect(subject.error?).to be true
        end

        it "returns false when error is not present" do
          subject.attributes.delete(:error)
          expect(subject.error?).to be false
        end
      end

    end
  end
end
