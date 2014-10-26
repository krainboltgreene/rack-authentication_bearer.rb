require "spec_helper"

describe Rack::AuthenticationBearer::VERSION do
  it "should be a string" do
    expect(Rack::AuthenticationBearer::VERSION).to be_kind_of(String)
  end
end
