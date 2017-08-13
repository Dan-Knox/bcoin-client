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

    end
  end
end
