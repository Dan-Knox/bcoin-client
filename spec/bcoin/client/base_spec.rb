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

      describe "#wallet_token" do
        it "returns the value of attributes[:token]" do
          subject.attributes[:token] = 123
          expect(subject.wallet_token).to eq 123
        end
      end

      describe "#token=" do
        it "sets the value of attributes[:token]" do
          subject.token = 123
          expect(subject.token).to eq 123
        end
      end

      describe "#attributes=" do
        it "symbolizes attributes keys" do
          expect(Base.new(client, {'key': 123}).attributes[:key]).to eq 123
        end
      end

      describe "#error" do
        it "accesses the error attribute" do
          subject.error = :error
          expect(subject.error).to eq :error
        end
      end

      describe "#error=" do
        it "sets the error attribute" do
          subject.error = :error
          expect(subject.error).to eq :error
          expect(subject.attributes[:error]). to eq :error
        end
      end

      describe "#refresh!" do
        context "without #wallet_token" do
          before do
            expect(subject).to receive(:get)
              .with('/')
              .and_return({refreshed: true})
          end

          it "calls #get with a base path" do
            subject.refresh!
          end

          it "replaces the current attributes" do
            subject.refresh!
            expect(subject.refreshed).to eq true
          end

          it "calls #attributes= to symbolize attributes" do
            expect(subject).to receive(:attributes=)
            subject.refresh!
          end

          it "returns self" do
            expect(subject.refresh!).to eq subject
          end
        end

        context "when #wallet_token is present" do
          it "merges the token parameter into options" do
            subject.attributes[:token] = 123
            expect(subject.client).to receive(:get)
              .with(subject.base_path + '/', {token: 123})
              .and_return({})
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

      describe "#respond_to?" do
        it "returns true for attribute methods" do
          expect(subject.respond_to?(:test)).to eq true
        end
      end

    end
  end
end
