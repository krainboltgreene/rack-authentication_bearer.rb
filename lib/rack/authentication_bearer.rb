module Rack
  class AuthenticationBearer
    require_relative "authentication_bearer/version"
    require_relative "authentication_bearer/invalid_bearer_token_error"
    require_relative "authentication_bearer/missing_bearer_token_error"
    PATTERN = /^Bearer ([\w\d\.~\+\/]+=*)/
    RACK_KEY = "rack.authentication"
    AUTHENTICATION_KEY = "HTTP_AUTHENTICATION"
    AUTHORIZATION_KEY = "HTTP_AUTHORIZATION"

    attr_reader :process
    private :process
    attr_reader :state
    private :state
    attr_reader :stack
    private :stack

    def initialize(stack, &process)
      @stack = stack
      @process = process if block_given?
    end

    def call(previous_state)
      @state = previous_state

      return stack.call(state) unless state
      return stack.call(state) unless process
      unless present?
        return stack.call(state.merge(RACK_KEY => Rack::AuthenticationBearer::MissingBearerTokenError))
      end
      unless matches?
        return stack.call(state.merge(RACK_KEY => Rack::AuthenticationBearer::InvalidBearerTokenError))
      end

      stack.call(state.merge!(RACK_KEY => process.call(shared)))
    end

    private def shared
      value.match(PATTERN)[1]
    end

    private def value
      @value ||= state[AUTHENTICATION_KEY] || state[AUTHORIZATION_KEY]
    end

    private def present?
      value.respond_to?(:length) && value.length > 0
    end

    private def matches?
      value.respond_to?(:match) && value.respond_to?(:length) && value.length > 0 && value.match?(PATTERN)
    end
  end
end
