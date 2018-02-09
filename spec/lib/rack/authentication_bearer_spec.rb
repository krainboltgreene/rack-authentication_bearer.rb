require "spec_helper"

describe Rack::AuthenticationBearer do
  let(:stack) { ->(a) { a } }
  let(:process) { ->(b) { Base64.urlsafe_decode64(b) }  }
  let(:middleware) { described_class.new(stack, &process) }

  describe "#call" do
    let(:call) { middleware.call(previous_state) }

    context "when the Authorization key exists and the value is valid" do
      let(:previous_state) { {"HTTP_AUTHORIZATION" => "Bearer #{Base64.urlsafe_encode64("This Is A Secret")}"} }

      it "sets the rack.authentication key with the decoded value" do
        expect(call).to include({"rack.authentication"=> "This Is A Secret"})
      end
    end

    context "when the Authorization key exists and the value is invalid" do
      let(:previous_state) { {"HTTP_AUTHORIZATION" => "Bearer "} }

      it "sets the key to an exception" do
        expect(call).to include("rack.authentication" => Rack::AuthenticationBearer::InvalidBearerTokenError)
      end

      it "does not call the process" do
        expect(process).to_not receive(:call)
      end
    end

    context "when the Authorization key does not exist" do
      let(:previous_state) { {} }

      it "sets the key to an exception" do
        expect(call).to include("rack.authentication" => Rack::AuthenticationBearer::MissingBearerTokenError)
      end

      it "does not call the process" do
        expect(process).to_not receive(:call)
      end
    end
  end
end
