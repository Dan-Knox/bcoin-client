require "spec_helper"

module Bcoin
  class Client
    RSpec.describe Base do

      let :client { Client.new }
      subject { Base.new(client, test: 123) }

      it "stores a reference to the current Bcoin::Client instance" do
        expect(subject.client).to be_a Bcoin::Client
      end

      it "defines a #base_path" do
        expect(subject.base_path).to eq '/base'
      end

      it "defines an #id" do
        expect(subject.id).to eq 'base'
      end

      it "includes HttpMethods" do
        expect(Base.include?(HttpMethods)).to eq true
      end

      it "symbolizes attributes keys" do
        expect(Base.new(client, {'test': 123}).attributes[:test]).to eq 123
      end

      describe "#wallet_token" do
        it "returns the value of attributes[:token]" do
          subject.attributes[:token] = 123
          expect(subject.wallet_token).to eq 123
        end
      end

      describe "#refresh!" do
        it "calls #get with a base path" do
          expect(subject).to receive(:get).with '/'
          subject.refresh!
        end

        it "replaces the current attributes" do
          expect(subject).to receive(:get).and_return({refreshed: true})
          subject.refresh!
          expect(subject.refreshed).to eq true
        end

        it "returns self" do
          expect(subject).to receive(:get).and_return({})
          expect(subject.refresh!).to eq subject
        end

        context "when #wallet_token is present" do
          it "merges the token parameter into options" do
            subject.attributes[:token] = 123
            expect(subject.client).to receive(:get).with subject.base_path + '/', {token: 123}
            subject.refresh!
          end
        end
      end

      describe "#method_missing" do
        it "it provides accessor methods for @attributes" do
          expect(subject.test).to eq 123
        end

        it "raises NoMethodError when an attribute doesn't exist" do
          expect{subject.missing}.to raise_error NoMethodError
        end
      end

    end
  end
end
