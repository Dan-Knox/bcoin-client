require "spec_helper"

module Bcoin
  class Client
    RSpec.describe Collection do

      let(:client) { Client.new }
      subject { Collection.new client, [1,2,3] }

      it "stores a reference to the current Bcoin::Client instance" do
        expect(subject.client).to be_a Bcoin::Client
      end

      it "keeps a collection array" do
        expect(subject.collection).to be_a Array
      end

      it "redefines #base_path" do
        expect(subject.base_path).to eq '/collection'
      end

      it "implements Enumerable" do
        subject.each do |w|
          expect([1,2,3].include?(w)).to eq true
        end
      end

      it "includes HttpMethods" do
        expect(Collection.include?(HttpMethods)).to eq true
      end

      describe "#refresh!" do
        it "performs an HTTP get on base_path" do
          expect(subject).to receive(:get).with '/'
          subject.refresh!
        end

        it "allows the path to be overriden" do
          expect(subject).to receive(:get).with '/override/'
          subject.refresh! '/override'
        end
      end

      describe "#error?" do
        it "returns false if error is not present" do
          expect(subject.error?).to eq false
        end

        it "returns true if error is present" do
          subject.error = :error
          expect(subject.error?).to eq true
        end
      end

      describe "#error=" do
        it "sets the error instance variable" do
          subject.error = :error
          expect(subject.error).to eq :error
        end
      end

    end
  end
end
