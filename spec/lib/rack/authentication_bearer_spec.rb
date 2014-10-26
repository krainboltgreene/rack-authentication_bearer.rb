require "spec_helper"

describe Rack::AuthenticationBearer do
  let(:application) { instance_double("Application") }
  let(:middleware) { described_class.new(application) }
  let(:verb) { "GET" }
  let(:status) { 200 }
  let(:headers) do
    {
      "REQUEST_METHOD" => verb,
      "Content-Type" => "text/plain",
      "Content-Length" => "0"
    }
  end
  let(:body) { "" }

  before(:each) do
    allow(application).to receive(:call).and_return([status, headers, body])
  end

  describe "#call" do

  end
end
