require "spec_helper"

module Bcoin
  class Client
    RSpec.describe Master do

      # See comment for attr_reader :client in account.rb
      let(:master_json) { load_mock! 'master.json' }
      let(:client) { Client.new }
      let(:wallet) { Wallet.new(client, id: 'wallet123', token: 123) }
      subject { Master.new(wallet, master_json) }

      it "extends Bcoin::Client::Base" do
        expect(Balance.ancestors.include?(Base)).to eq true
      end

      it "stores a reference to the current Bcoin::Client::Wallet instance" do
        expect(subject.client).to be_a Bcoin::Client::Wallet
      end

      it "redefines a #base_path" do
        expect(subject.base_path).to eq '/master/'
      end

    end
  end
end
